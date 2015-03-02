import happybase
import tangelo
import datetime
from entity import Entity
import data_connector
from datawake.conf import datawakeconfig


class HBASEDataConnector(data_connector.DataConnector):
    def __init__(self, config):
        data_connector.DataConnector.__init__(self)
        self.config = config
        self.hbase_conn = None


    def open(self):
        self.hbase_conn = happybase.Connection(host=self.config['host'],port=self.config['port'])

    def close(self):
        if self.hbase_conn is not None:
            self.hbase_conn.close()

    def get_domain_items(self, name, limit):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['domain_table'])
            rowkey = "%s\0" % name
            entities = []
            for item in hbase_table.scan(row_prefix=rowkey, limit=limit):
                entities.append(item[0].decode('utf-8'))
            return entities
        finally:
            self.close()

    def get_domain_entity_matches(self, domain, type, values):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['domain_table'])
            rowkey = "%s\0%s\0" % (domain, type)
            found = []
            for value in values:
                prefix = ("%s%s" % (rowkey, value)).encode('utf-8')
                for item in hbase_table.scan(row_prefix=prefix):
                    found.append(value)
            return found
        finally:
            self.close()

    def get_extracted_domain_entities_from_urls(self, domain, urls, type=None):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['extracted_domain_table'])
            entity_dict = dict()
            for url in urls:
                entity_dict[url] = dict()
                prefix = ( "%s\0%s\0" % (domain, url)).encode('utf-8')
                for d in hbase_table.scan(row_prefix=prefix):
                    tokens = d[0].decode('utf-8').split("\0")
                    type = tokens[2]
                    value = tokens[3]
                    if type not in entity_dict[url]:
                        entity_dict[url][type] = [value]
                    else:
                        entity_dict[url][type].append(value)
            return entity_dict
        finally:
            self.close()

    def _check_conn(self):
        self.open()

    def get_extracted_entities_from_urls(self, urls, type=None):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['extracted_all_table'])
            results = {}
            for url in urls:
                prefix = ("%s\0" % url).encode('utf-8')
                for d in hbase_table.scan(row_prefix=prefix):
                    if url not in results:
                        results[url] = {}
                    tokens = d[0].decode('utf-8').split("\0")
                    url = tokens[0]
                    type = tokens[1]
                    value = tokens[2]
                    if type not in results[url]:
                        results[url][type] = [value]
                    else:
                        results[url][type].append(value)
            return results
        finally:
            self.close()

    def delete_domain_items(self, domain_name):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['extracted_domain_table'])
            rowkey_prefix = (domain_name + '\0').encode('utf-8')
            batch_delete = hbase_table.batch(batch_size=20)
            for key in hbase_table.scan(row_prefix=rowkey_prefix):
                batch_delete.delete(row=key[0])
            batch_delete.send()
        finally:
            self.close()

    def get_extracted_entities_with_domain_check(self, urls, types=[], domain='default'):
        """
        Return all entities extracted from a given set of urls, indication which entities were found in the domain
        :param urls:  list of urls to look up
        :param types: list of extract_types to filter on.  empty list will search on all types
        :param domain:  the domain to check for memebership against
        :return:  dict of results with the form  { url: { extract_type: { extract_value: in_domain, .. }, .. } , ..} where in_domain is 'y' or 'n'
        """
        try:
            self._check_conn()
            results = {}
            hbase_all_table = self.hbase_conn.table(self.config['extracted_all_table'])
            hbase_domain_table = self.hbase_conn.table(self.config['extracted_domain_table'])
            prefixes = []

            # first look up results in the extrcated_all table
            for url in urls:
                if len(types) > 0:
                    for type in types:
                        prefixes.append("%s\0%s" % (url,type))
                else:
                    prefixes.append("%s\0" % (url))
            for prefix in prefixes:
                for d in hbase_all_table.scan(row_prefix=prefix.encode('utf-8')):
                    tokens = d[0].decode('utf-8').split("\0")
                    url = tokens[0]
                    type = tokens[1]
                    value = tokens[2]
                    if url not in results: results[url] = {}
                    if type not in results[url]: results[url][type] = {}
                    results[url][type][value] = 'n'

            #now look up results in the domain table
            for prefix in prefixes:
                prefix = domain+'\0'+prefix
                for d in hbase_domain_table.scan(row_prefix=prefix.encode('utf-8')):
                    tokens = d[0].decode('utf-8').split("\0")
                    url = tokens[1]
                    type = tokens[2]
                    value = tokens[3]
                    if url not in results: results[url] = {}
                    if type not in results[url]: results[url][type] = {}
                    results[url][type][value] = 'y'

            return results
        finally:
            self.close()


    def get_extracted_domain_entities_for_urls(self, domain, urls):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['extracted_domain_table'])
            entity_values = []
            for url in urls:
                prefix = ("%s\0%s\0" % (domain, url)).encode('utf-8')
                for d in hbase_table.scan(row_prefix=prefix):
                    tokens = d[0].decode('utf-8').split("\0")
                    value = tokens[3]
                    entity_values.append(value)
            return entity_values
        finally:
            self.close()

    def get_extracted_entities_list_from_urls(self, urls):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['extracted_all_table'])
            data = []
            for url in urls:
                for d in hbase_table.scan(row_prefix="%s\0" % url.encode('utf-8')):
                    data.append(d[0])
            return data
        finally:
            self.close()

    def get_matching_entities_from_url(self, urls):
        entities = self.get_extracted_entities_list_from_urls(urls)
        url_dict = dict()
        for url in urls:
            url_dict[url] = set()

        def new_entity(x):
            values = x.split("\0")
            if len(values) == 3:
                url_dict[values[0]].add(Entity(dict(type=values[1], name=values[2])))

        map(lambda x: new_entity(x), entities)
        vals = url_dict.values()
        return map(lambda entity: entity.item["name"], set.intersection(*vals))

    def add_new_domain_items(self, domain_items):
        try:
            self._check_conn()
            hbase_table = self.hbase_conn.table(self.config['domain_table'])
            batch_put = hbase_table.batch(batch_size=100)
            for i in domain_items:
                batch_put.put(row=i.encode('utf-8'), data={"colFam:dt": str(datetime.datetime.now())})

            batch_put.send()
        finally:
            self.close()