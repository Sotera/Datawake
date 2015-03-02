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

import mysql.connector
import tangelo

from datawake.util.dataconnector.data_connector import DataConnector


class MySqlEntityDataConnector(DataConnector):
    """Provides connection to local mysql database for extracted entity data"""


    def __init__(self, config):
        """
            :param config:  database connection info and table names
                {
                    user:...,
                    database:...,
                    password:...,
                    host:....,
                }
            :return:  a new EntityDataConnector for a mysql database
            """
        DataConnector.__init__(self)
        self.config = config
        self.cnx = None


    def open(self):
        """ Open a new database connection. """

        self.close()
        user = self.config['user']
        db = self.config['database']
        pw = self.config['password']
        host = self.config['host']
        port = self.config['port']
        self.cnx = mysql.connector.connect(user=user, password=pw, host=host, database=db, port=port)


    def close(self):
        """Close any existing database connection. """

        if self.cnx is not None:
            try:
                self.cnx.close()
            except:
                pass
            finally:
                self.cnx = None


    def _check_conn(self):
        """Open a new database conneciton if one does not currently exist."""

        if self.cnx is None:
            self.open()


    def get_matching_entities_from_url(self, urls):
        self._check_conn()
        urls_in = "(" + (','.join(['"%s"' % urls[i] for i in range(len(urls))])) + ")"
        params = []
        sql = """select distinct a.feature_value from general_extractor_web_index a inner join
                 (
                  select url,feature_type,feature_value from general_extractor_web_index
                  ) b where a.feature_value = b.feature_value
                  AND a.url in %s
                  AND b.url in %s
                  AND a.url != b.url;""" % (urls_in, urls_in)
        try:
            cursor = self.cnx.cursor()
            cursor.execute(sql, params)
            results = []
            for row in cursor.fetchall():
                results.append(row[0])
            return results
        except:
            self.close()
            raise


    def get_extracted_entities_from_urls(self, urls, type=None):
        """
        Returns all extracted attributs for a url
        :param
            urls:  list of urls to extract entities from
            type = None for all types,  specify a type for that type only.
        :return: {url: {attrType: [value1,value2,..], ... }}
        """
        self._check_conn()
        urls_in = "(" + ( ','.join(['%s' for i in range(len(urls))]) ) + ")"
        params = []
        params.extend(urls)
        if type is None:
            sql = "select url,feature_type,feature_value from general_extractor_web_index where url in  " + urls_in
        else:
            sql = "select url,feature_type,feature_value from general_extractor_web_index where url in " + urls_in + "  and feature_type = %s"
            params.append(type)

        self._check_conn()
        try:
            cursor = self.cnx.cursor()
            cursor.execute(sql, params)
            results = {}
            for row in cursor.fetchall():
                url = row[0]
                attr = row[1]
                value = row[2]
                if url not in results:
                    results[url] = {}
                if attr not in results[url]:
                    results[url][attr] = [value]
                else:
                    results[url][attr].append(value)
            return results
        except:
            self.close()
            tangelo.log(sql)
            tangelo.log(str(params))
            raise

    def get_extracted_domain_entities_for_urls(self, domain_id, urls):
        self._check_conn()
        urls_in = "(" + ( ','.join(['%s' for i in range(len(urls))]) ) + ")"
        params = [domain]
        params.extend(urls)
        sql = "select feature_value from domain_extractor_web_index where domain_id = %s and url in  " + urls_in
        self._check_conn()
        try:
            cursor = self.cnx.cursor()
            cursor.execute(sql, params)
            results = []
            for row in cursor.fetchall():
                results.append(row[0])
            return results
        except:
            self.close()
            raise


    def get_extracted_domain_entities_from_urls(self, domain_id, urls, type=None):
        """
        Returns all extracted attributs for a url
        :param
            urls:  list of urls to extract entities from
            type = None for all types,  specify a type for that type only.
        :return: {attrType: [value1,value2,..], ... }
        """
        self._check_conn()
        urls_in = "(" + ( ','.join(['%s' for i in range(len(urls))]) ) + ")"
        params = [domain_id]
        params.extend(urls)
        if type is None:
            sql = "select url,feature_type,feature_value from domain_extractor_web_index where domain_id = %s and url in  " + urls_in
        else:
            sql = "select url,feature_type,feature_value from domain_extractor_web_index where domain_id = %s and url in " + urls_in + "  and feature_type = %s"
            params.append(type)

        self._check_conn()
        try:
            cursor = self.cnx.cursor()
            cursor.execute(sql, params)
            results = {}
            for row in cursor.fetchall():
                url = row[0]
                attr = row[1]
                value = row[2]
                if url not in results:
                    results[url] = {}
                if attr not in results[url]:
                    results[url][attr] = [value]
                else:
                    results[url][attr].append(value)
            return results
        except:
            self.close()
            raise


    def get_extracted_entities_with_domain_check(self, urls, types=[], domain='default'):
        """
        Return all entities extracted from a given set of urls, indication which entities were found in the domain
        :param urls:  list of urls to look up
        :param types: list of extract_types to filter on.  empty list will search on all types
        :param domain:  the domain to check for memebership against
        :return:  dict of results with the form  { url: { extract_type: { extract_value: in_domain, .. }, .. } , ..} where in_domain is 'y' or 'n'
        """
        assert (len(urls) > 0)
        self._check_conn()
        cursor = self.cnx.cursor()
        try:
            params = []
            params.extend(urls)
            urls_in = "(" + ( ','.join(['%s' for i in range(len(urls))]) ) + ")"
            sql = "select url,feature_type,feature_value from general_extractor_web_index where  url in " + urls_in
            params = []
            params.extend(urls)
            if len(types) > 0:
                params.extend(types)
                types_in = "(" + ( ','.join(['%s' for i in range(len(types))]) ) + ")"
                sql = sql + " and feature_type in " + types_in

            cursor.execute(sql, params)
            allEntities = {}
            for row in cursor.fetchall():
                url = row[0]
                attr = row[1]
                value = row[2]
                if url not in allEntities:
                    allEntities[url] = {}
                if attr not in allEntities[url]:
                    allEntities[url][attr] = {}
                allEntities[url][attr][value] = 'n'

            params = [domain]
            params.extend(urls)
            sql = "select url,feature_type,feature_value from domain_extractor_web_index where  domain = %s and url in " + urls_in
            if len(types) > 0:
                params.extend(types)
                types_in = "(" + ( ','.join(['%s' for i in range(len(types))]) ) + ")"
                sql = sql + " and feature_type in " + types_in

            cursor.execute(sql, params)
            for row in cursor.fetchall():
                url = row[0]
                attr = row[1]
                value = row[2]
                if url not in allEntities:
                    allEntities[url] = []
                if attr not in allEntities[url]:
                    allEntities[url][attr] = {}
                allEntities[url][attr][value] = 'y'

            cursor.close()
            return allEntities

        except:
            self.close()
            raise


    # # DOMAINS  ####




    def get_domain_entity_matches(self, domain_id, type, values):
        self._check_conn()
        cursor = self.cnx.cursor()
        sql = ""
        params = []
        max = len(values) - 1
        for i in range(len(values)):
            params.append(domain_id)
            params.append(type)
            sql = sql + "select feature_value from datawake_domain_entities where domain_id = %s and feature_type=%s"
            if i < max:
                sql = sql + " union all "
        try:
            cursor.execute(sql, params)
            rows = cursor.fetchall()
            cursor.close()
            return map(lambda x: x[0],rows)
        except:
            self.close()
            raise


    def get_domain_items(self, name, limit):
        self._check_conn()
        cursor = self.cnx.cursor()
        sql = "select rowkey from datawake_domain_entities where rowkey >= %s and rowkey <= %s limit %s"
        params = [name + '\0', name + "~", limit]
        try:
            cursor.execute(sql, params)
            rows = cursor.fetchall()
        except:
            self.close()
            raise
        return map(lambda x: x[0], rows)


    def delete_domain_items(self, domain_name):
        self._check_conn()
        cursor = self.cnx.cursor()
        full_name = domain_name + '\0'
        sql = "delete from datawake_domain_entities where INSTR(rowkey, %s)"
        params = [full_name]
        try:
            cursor.execute(sql, params)
            self.cnx.commit()
        except:
            self.close()
            raise

    def add_new_domain_items(self, domain_items):
        self._check_conn()
        cursor = self.cnx.cursor()
        params = []
        # item_list = ','.join(map(lambda x: "('%s','')" % x, domain_items))
        try:
            for item in domain_items:
                sql = "insert into datawake_domain_entities (rowkey) value (%s)"
                cursor.execute(sql, [item])
            self.cnx.commit()
            cursor.close()
            return True
        except:
            self.close()
            return False




    def insert_entities(self, url, feature_type, feature_values):
        self._check_conn()
        cursor = self.cnx.cursor()
        try:
            for feature_value in feature_values:
                sql = "select count(1) from general_extractor_web_index where url = %s and feature_type = %s and feature_value = %s"
                params = [url,feature_type,feature_value]
                cursor.execute(sql,params)
                count = cursor.fetchall()[0][0]
                if count == 0:
                    sql = "INSERT INTO general_extractor_web_index (url,feature_type,feature_value) VALUES (%s,%s,%s)"
                    cursor.execute(sql,params)
            self.cnx.commit()
            cursor.close()
        except:
            self.close()
            raise



    def insert_domain_entities(self, domain_id,url, feature_type, feature_values):
        self._check_conn()
        cursor = self.cnx.cursor()
        try:
            for feature_value in feature_values:
                sql = "select count(1) from domain_extractor_web_index where domain_id = %s and url = %s and feature_type = %s and feature_value = %s"
                params = [domain_id,url,feature_type,feature_value]
                cursor.execute(sql,params)
                count = cursor.fetchall()[0][0]
                if count == 0:
                    sql = "INSERT INTO domain_extractor_web_index (domain_id,url,feature_type,feature_value) VALUES (%s,%s,%s,%s)"
                    cursor.execute(sql,params)
            self.cnx.commit()
            cursor.close()
        except:
            self.close()
            raise




