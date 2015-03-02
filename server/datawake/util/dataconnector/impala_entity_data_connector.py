"""

Copyright 2014 Sotera Defense Solutions, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

"""

import random
import threading
from Queue import Queue
from Queue import Empty

from impala.dbapi import connect
import tangelo

from entity import Entity
from datawake.conf import datawakeconfig
from datawake.util.dataconnector.data_connector import DataConnector
import datetime

THREADS_PER_HOST = 2


class ImpalaQueryThread(threading.Thread):
    def __init__(self, host, port, q, do_work):
        threading.Thread.__init__(self)
        self.host = host
        self.port = int(port)
        self.q = q
        self.do_work = do_work

    def run(self):
        cnx = connect(host=self.host, port=self.port)
        cursor = cnx.cursor()
        try:
            while True:
                work_item = self.q.get(block=False)
                self.do_work(cursor, work_item)
        except Empty:
            pass
        finally:
            cnx.close()


class ClusterEntityDataConnector(DataConnector):
    """Provides connection to local mysql database for extracted entity data"""


    def __init__(self, config):
        DataConnector.__init__(self)
        self.config = config
        self.cnx = None
        self.lock = threading.Lock()


    def open(self):
        host = random.choice(self.config['hosts'])
        self.cnx = connect(host=host, port=int(self.config['port']))


    def close(self):
        if self.cnx is not None:
            try:
                self.cnx.close()
            except:
                pass
            finally:
                self.cnx = None

    def _check_conn(self):
        if self.cnx is None:
            self.open()

    def queue_impala_query(self, result_method, results, work_item_iterator):
        q = Queue()
        for work_item in work_item_iterator():
            q.put(work_item)

        # define the work function

        lock = threading.Lock()

        def work_method(cursor, work_item):
            cursor.execute(work_item['sql'], work_item['params'])
            for row in cursor:
                result_method(row, lock, results)

        threads = []
        hosts = self.config['hosts']
        max_threads = THREADS_PER_HOST * len(hosts)
        total_work = q.qsize()
        if total_work < len(hosts):
            hosts = random.sample(hosts, total_work)
        else:
            while len(hosts) < max_threads and total_work > len(hosts):
                diff = total_work - len(hosts)
                diff = min(diff, self.config['hosts'])
                diff = min(diff, max_threads - len(hosts))
                hosts.extend(random.sample(self.config['hosts'], diff))

        for host in hosts:
            t = ImpalaQueryThread(host, self.config['port'], q, work_method)
            t.start()
            threads.append(t)


        # execute with all threads
        for thread in threads:
            thread.join()

        return results


    def get_extracted_entities_from_urls(self, urls, type=None):

        def work_item_iterator():
            sql = "select rowkey from "+self.config['extracted_all_table']
            for url in urls:
                work_item = {}
                rowkey = ("%s\0" % url).encode('utf-8') if type == None else ("%s\0%s\0" % (url,type)).encode('utf-8')

                work_item['sql'] = sql + " where rowkey >= %(startkey)s and rowkey < %(endkey)s "
                work_item['params'] = {'startkey': rowkey, 'endkey': rowkey + "~"}
                yield work_item

        # define the work function

        def append_to_list(row, lock, results):
            tokens = row[0].decode('utf-8').split("\0")
            url = tokens[0]
            attr = tokens[1]
            value = tokens[2]
            with lock:
                if url not in results:
                    results[url] = {}
                if attr not in results[url]:
                    results[url][attr] = [value]
                else:
                    results[url][attr].append(value)

        results = {}
        return self.queue_impala_query(append_to_list, results, work_item_iterator)


    def get_extracted_entities_with_domain_check(self, urls, types=[], domain='default'):
        all_entities = {}
        if len(types) > 0:
            for type in types:
                all_entities.update( self.get_extracted_entities_from_urls(urls,type=type) )
        else:
            all_entities.update( self.get_extracted_entities_from_urls(urls) )

        domain_entities = {}
        if len(types) > 0:
            for type in types:
                domain_entities.update( self.get_extracted_domain_entities_from_urls(domain,urls,type=type))
        else:
            domain_entities.update( self.get_extracted_domain_entities_from_urls(domain,urls))


        merged = {}
        for url in all_entities:
            for type,values in all_entities[url].iteritems():
                if url not in merged: merged[url] = {}
                if type not in merged[url]: merged[url][type] = {}
                for value in values:
                    if value not in merged[url][type]: merged[url][type][value] = 'n'

        for url in domain_entities:
            for type,values in domain_entities[url].iteritems():
                if url not in merged: merged[url] = {}
                if type not in merged[url]: merged[url][type] = {}
                for value in values:
                    if value not in merged[url][type]: merged[url][type][value] = 'y'

        return merged



    # # DOMAINS  ####
    def get_domain_items(self, name, limit):
        self._check_conn()
        cursor = self.cnx.cursor()
        sql = "select rowkey from "+self.config['domain_table']+" where rowkey >= %(startkey)s and rowkey < %(endkey)s limit %(limit)s"
        params = {
            'startkey': name + '\0',
            'endkey': name + '\0~',
            'limit': limit
        }
        try:
            cursor.execute(sql, params)
            rows = cursor.fetchall()
        except:
            self.close()
            raise
        return map(lambda x: x[0], rows)


    def get_domain_entity_matches(self, domain, type, values):

        def work_item_iterator():
            sql = "select rowkey from "+self.config['domain_table']
            for value in values:
                work_item = {}
                rowkey = ("%s\0%s\0%s" % (domain, type, value)).encode('utf-8')
                work_item['sql'] = sql + " where rowkey >= %(startkey)s and rowkey < %(endkey)s "
                work_item['params'] = {'startkey': rowkey,'endkey': rowkey + "~"}
                yield work_item

        def append_to_list(row, lock, results):
            tokens = row[0].decode('utf-8').split("\0")
            value = tokens[2]
            with lock:
                results.append(value)

        results = []
        return self.queue_impala_query(append_to_list, results, work_item_iterator)


    def get_extracted_domain_entities_from_urls(self, domain, urls, type=None):
        def work_item_iterator():
            sql = "select rowkey from "+self.config['extracted_domain_table']
            for url in urls:
                work_item = {}
                rowkey = ("%s\0%s\0" % (domain, url)).encode('utf-8') if type == None else ("%s\0%s\0%s\0" % (domain, url,type)).encode('utf-8')
                work_item['sql'] = sql + " where rowkey >= %(startkey)s and rowkey < %(endkey)s "
                work_item['params'] = {'startkey': rowkey, 'endkey': rowkey + "~"}
                yield work_item

        def append_to_list(row, lock, results):
            tokens = row[0].decode('utf-8').split("\0")
            url = tokens[1]
            type = tokens[2]
            value = tokens[3]
            with lock:
                if url not in results:
                    results[url] = {}
                if type not in results[url]:
                    results[url][type] = [value]
                else:
                    results[url][type].append(value)

        results = {}
        return self.queue_impala_query(append_to_list, results, work_item_iterator)


    def get_extracted_domain_entities_for_urls(self, domain, urls):
        def work_item_iterator():
            sql = "select rowkey from "+self.config['extracted_domain_table']
            for url in urls:
                work_item = {}
                rowkey = ("%s\0%s\0" % (domain, url)).encode('utf-8')
                work_item['sql'] = sql + " where rowkey >= %(startkey)s and rowkey < %(endkey)s "
                work_item['params'] = { 'startkey': rowkey, 'endkey': rowkey + "~"}

        def append_to_list(row, lock, results):
            tokens = row[0].decode('utf-8').split("\0")
            value = tokens[3]
            with lock:
                results.append(value)

        results = []
        return self.queue_impala_query(append_to_list, results, work_item_iterator)



    def get_extracted_entities_list_from_urls(self, urls):
        def work_item_iterator():
            sql = "select rowkey from "+self.config['extracted_all_table']
            for url in urls:
                work_item = {}
                rowkey = "%s\0" % url
                work_item['sql'] = sql + " where rowkey >= %(startkey)s and rowkey < %(endkey)s "
                work_item['params'] = {'startkey': rowkey, 'endkey': rowkey + "~"}
                yield work_item

        def append_to_list(row, lock, results):
            with lock:
                results.append(row[0].decode('utf-8'))

        results = []
        return self.queue_impala_query(append_to_list, results, work_item_iterator)



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



    def add_new_domain_items(self, domain_items):
        self._check_conn()
        cursor = self.cnx.cursor()
        values = []
        params = {}
        i = 0
        dt = str(datetime.datetime.now())
        for item in domain_items:
            key = "value"+str(i)
            values.append("(%("+key+")s,\""+dt+"\" )")
            params[key] = item.encode('utf-8')
            i = i + 1
        sql = "INSERT INTO TABLE "+self.config['domain_table']+" (rowkey,dt) VALUES "+ ','.join(values)
        try:
            cursor.execute(sql, params)
        except:
            self.close()
            raise

