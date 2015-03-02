import os


"""
All configuration for the datawake web server.
To change the configuration you should set the appropriate environment variables.
Environment variables are used to set conf to conform to standard docker practices.

REQUIRED ENVIRONMENT VARIABLES

DW_DB: database name
DW_DB_USER: database username
DW_DB_PASSWORD: database password
DW_DB_HOST: database ip address or hostname
DW_DB_PORT: database port


OPTIONAL ENVIRONMENT VARIABLES

DW_GOOGLE_CLIENT_IDS: list of client ids used for google user authentication
DW_MOCK_AUTH:  If set actual user authentication is bypassed for browser plugins. (for dev / demos only)
DW_MOCK_FORENSIC_AUTH:  If set actual user authentication is bypassed for forensic views. (for dev / demos only)
DW_CONN_TYPE:  Determines mysql or impala / hbase is used to store the generated web index data. default=mysql. can by mysql or cluster
DW_IMPALA_HOSTS: Comma separated list of impala hosts (cluster only)
DW_IMPALA_PORT: impala port
DW_HBASE_HOST: hbase host name (cluster only)
DW_HBASE_NAMESPACE: hbase namespace (cluster only, default: default)
DW_HBASE_DOMAIN_ENTITIES_TABLE (cluster only, default: datawake_domain_entities_hbase)
DW_HBASE_EXTRACTED_ALL_TABLE (cluster only, default: general_extractor_web_index_hbase)
DW_HBASE_EXTRACTED_DOMAIN_TABLE (cluster only, default: domain_extractor_web_index_hbase)
DW_EXTERNAL_LINK_NAMES: Comma separated list of links names to provide for extracted features found in the domain index.
DW_EXTERNAL_LINK_VALUES: Comma separated list of links to provide for extracted features found in the domain index.
    The link text may contain "$ATTR" and/or "$VALUE", which will be replaced with an extracted type and value such as "phone" and "5555555555"


"""

VERSION_NUMBER="0.6-SNAPSHOT"

# enforce requirement for all required paramaters to be set

REQUIRED_PARAMS = [
    'DW_DB',
    'DW_DB_USER',
    'DW_DB_PASSWORD',
    'DW_DB_HOST',
    'DW_DB_PORT',
]
not_found = []
for param in REQUIRED_PARAMS:
    if param not in os.environ:
        not_found.append(param)
if len(not_found) > 0:
    raise ValueError("Datawake required environment variables not set: "+str(not_found))




# read required params

DATAWAKE_CORE_DB = {
    'database': os.environ['DW_DB'],
    'user': os.environ['DW_DB_USER'],
    'password':os.environ['DW_DB_PASSWORD'],
    'host': os.environ['DW_DB_HOST'],
    'port': os.environ['DW_DB_PORT']
}




# read optional params


CLIENT_IDS = []
if 'DW_GOOGLE_CLIENT_IDS' in os.environ:
    CLIENT_IDS = os.environ['DW_GOOGLE_CLIENT_IDS'].strip().split(',')


MOCK_AUTH = 'DW_MOCK_AUTH' in os.environ
MOCK_FORENSIC_AUTH = 'DW_MOCK_FORENSIC_AUTH' in os.environ


# can be "cluster" or "mysql"
ENTITY_CONNECTION = 'mysql'
if 'DW_CONN_TYPE' in os.environ:
    ENTITY_CONNECTION = os.environ['DW_CONN_TYPE'].lower()
if ENTITY_CONNECTION != 'mysql' and ENTITY_CONNECTION != 'cluster-impala' and ENTITY_CONNECTION != 'cluster-hbase':
    raise ValueError("DW_CONN_TYPE must be 'mysql' or 'cluster-impala', or 'cluster-hbase' if set. ")


IMPALA_HOSTS = os.environ['DW_IMPALA_HOSTS'].strip().split(',') if 'DW_IMPALA_HOSTS' in os.environ else []
IMPALA_PORT = os.environ['DW_IMPALA_PORT'] if 'DW_IMPALA_PORT' in os.environ else '21050'
IMPALA_DB = os.environ['DW_IMPALA_DB'] if 'DW_IMPALA_DB' in os.environ else 'default'
IMPALA_DOMAIN_ENTITIES_TABLE = os.environ['DW_IMPALA_DOMAIN_ENTITIES_TABLE'] if 'DW_IMPALA_DOMAIN_ENTITIES_TABLE' in os.environ else 'datawake_domain_entities'
IMPALA_EXTRACTED_ALL_TABLE = os.environ['DW_IMPALA_EXTRACTED_ALL_TABLE'] if 'DW_IMPALA_EXTRACTED_ALL_TABLE' in os.environ else 'general_extractor_web_index'
IMPALA_EXTRACTED_DOMAIN_TABLE = os.environ['DW_IMPALA_EXTRACTED_DOMAIN_TABLE'] if 'DW_IMPALA_EXTRACTED_DOMAIN_TABLE' in os.environ else 'domain_extractor_web_index'


HBASE_HOST = os.environ['DW_HBASE_HOST'] if 'DW_HBASE_HOST' in os.environ else 'NO HBASE HOST SET'
HBASE_PORT = os.environ['DW_HBASE_PORT'] if 'DW_HBASE_PORT' in os.environ else '9090'
HBASE_NAMESPACE = os.environ['DW_HBASE_NAMESPACE'] if 'DW_HBASE_NAMESPACE' in os.environ else 'default'
HBASE_DOMAIN_ENTITIES_TABLE = os.environ['DW_HBASE_DOMAIN_ENTITIES_TABLE'] if 'DW_HBASE_DOMAIN_ENTITIES_TABLE' in os.environ else 'datawake_domain_entities_hbase'
HBASE_EXTRACTED_ALL_TABLE = os.environ['DW_HBASE_EXTRACTED_ALL_TABLE'] if 'DW_HBASE_EXTRACTED_ALL_TABLE' in os.environ else 'general_extractor_web_index_hbase'
HBASE_EXTRACTED_DOMAIN_TABLE = os.environ['DW_HBASE_EXTRACTED_DOMAIN_TABLE'] if 'DW_HBASE_EXTRACTED_DOMAIN_TABLE' in os.environ else 'domain_extractor_web_index_hbase'



#
# Link to external tools.  provide a list of links in the form:
#   {'display':'display name','link':"..."}
# The link text may contain "$ATTR" and/or "$VALUE"
# which will be replaced with an extracted type and value such as "phone" and "5555555555"
#
EXTERNAL_LINKS = []
if 'DW_EXTERNAL_LINK_NAMES' in os.environ or 'DW_EXTERNAL_LINK_VALUES' in os.environ :
    try:
        linkNames = os.environ['DW_EXTERNAL_LINK_NAMES'].strip().split(',')
        linkValues = os.environ['DW_EXTERNAL_LINK_VALUES'].strip().split(',')
        for i in range( max (len(linkNames),len(linkValues))):
            EXTERNAL_LINKS.append({'display':linkNames[i],'link':linkValues[i]})
    except:
        raise ValueError("if DW_LINK_NAMES or DW_LINK_VALUES are set, both must be set and of equal length")


