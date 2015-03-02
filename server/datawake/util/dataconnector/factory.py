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
from datawake.conf import datawakeconfig


if datawakeconfig.ENTITY_CONNECTION == 'cluster-impala':
    from datawake.util.dataconnector.impala_entity_data_connector import ClusterEntityDataConnector
elif datawakeconfig.ENTITY_CONNECTION == 'cluster-hbase':
    from datawake.util.dataconnector.hbase_entity_data_connector import HBASEDataConnector
elif datawakeconfig.ENTITY_CONNECTION == 'mysql':
    from datawake.util.dataconnector.local_entity_data_connector import MySqlEntityDataConnector


def get_entity_data_connector():
    if datawakeconfig.ENTITY_CONNECTION == 'cluster-impala':
        prefix = datawakeconfig.IMPALA_DB+'.' if datawakeconfig.IMPALA_DB != 'default' and datawakeconfig.IMPALA_DB != '' else ''
        config = {
            'hosts': datawakeconfig.IMPALA_HOSTS,
            'port': datawakeconfig.IMPALA_PORT,
            'domain_table': prefix+datawakeconfig.IMPALA_DOMAIN_ENTITIES_TABLE,
            'extracted_all_table': prefix+datawakeconfig.IMPALA_EXTRACTED_ALL_TABLE,
            'extracted_domain_table': prefix+datawakeconfig.IMPALA_EXTRACTED_DOMAIN_TABLE
        }
        return ClusterEntityDataConnector(config)
    elif datawakeconfig.ENTITY_CONNECTION == 'mysql':
        config = datawakeconfig.DATAWAKE_CORE_DB
        return MySqlEntityDataConnector(config)
    elif datawakeconfig.ENTITY_CONNECTION == 'cluster-hbase':
        prefix = '' if datawakeconfig.HBASE_NAMESPACE == 'default' or datawakeconfig.HBASE_NAMESPACE == '' else datawakeconfig.HBASE_NAMESPACE+':'
        config = {
            'host': datawakeconfig.HBASE_HOST,
            'port': datawakeconfig.HBASE_PORT,
            'domain_table': prefix+datawakeconfig.HBASE_DOMAIN_ENTITIES_TABLE,
            'extracted_all_table': prefix+datawakeconfig.HBASE_EXTRACTED_ALL_TABLE,
            'extracted_domain_table': prefix+datawakeconfig.HBASE_EXTRACTED_DOMAIN_TABLE
        }
        return HBASEDataConnector(config)
    else:
        raise ValueError("ENTITY_CONNECTION must be mysql, cluster-impala, or cluster-hbase, not " + datawakeconfig.ENTITY_CONNECTION)








