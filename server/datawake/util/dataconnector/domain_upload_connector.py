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

import pyodbc
import tangelo


class BasicConnector(object):
    connection_information = {

    }

    def __init__(self, connection_string, table_name, attribute_column, value_column):
        self.connection_information["connection_string"] = connection_string.encode("ascii", "ignore")
        self.connection_information["table_name"] = table_name.encode("ascii", "ignore")
        self.connection_information["attribute_column"] = attribute_column.encode("ascii", "ignore")
        self.connection_information["value_column"] = value_column.encode("ascii", "ignore")

    def open(self):
        raise NotImplementedError("Implement method open()")

    def close(self):
        raise NotImplementedError("Implement method close()")

    def get_domain_items(self):
        raise NotImplementedError("Implement method get_domain_items()")


class ODBCConnector(BasicConnector):
    connection = None

    def __init__(self, connection_string, table_name, attribute_column, value_column):
        super(ODBCConnector, self).__init__(connection_string, table_name, attribute_column, value_column)

    def open(self):
        self.connection = pyodbc.connect(self.connection_information["connection_string"])

    def close(self):
        if self.connection is not None:
            self.connection.close()

    def get_domain_items(self):
        cursor = None
        try:
            self.open()
            cursor = self.connection.cursor()
            sql_cmd = "select " + self.connection_information["attribute_column"] + "," + self.connection_information["value_column"] + " from " + self.connection_information["table_name"] + ";"
            #tangelo.log(sql_cmd)
            cursor.execute(sql_cmd)
            rows = cursor.fetchall()
            if rows:
                return rows
            else:
                return []
        finally:
            if cursor is not None:
                cursor.close()
            self.close()


class ConnectorUtil:
    def __init__(self):
        pass

    @staticmethod
    def get_database_connector(connection_string, table_name, attribute_column, value_column):
        return ODBCConnector(connection_string, table_name, attribute_column, value_column)