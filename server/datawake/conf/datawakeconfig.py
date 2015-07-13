import os


"""
All configuration for the datawake web server.
To change the configuration you should set the appropriate environment variables.
Environment variables are used to set conf to conform to standard docker practices.

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

FORENSIC_ES_URL: url for forensic view elastic search
FORENSIC_ES_INDEX: the index to search, defaults to none (all indexes)
FORENSIC_ES_CRED:  username:password for elastic search
FORENSIC_ES_MRPN: max elastic search results to return per node
"""

VERSION_NUMBER="0.7-SNAPSHOT"

FORENSIC_ES_URL = os.environ['FORENSIC_ES_URL'] if 'FORENSIC_ES_URL' in os.environ else ''
FORENSIC_ES_INDEX = os.environ['FORENSIC_ES_INDEX'] if 'FORENSIC_ES_INDEX' in os.environ else ''
FORENSIC_ES_CRED = os.environ['FORENSIC_ES_CRED'] if 'FORENSIC_ES_CRED' in os.environ else ''
FORENSIC_ES_MRPN = os.environ['FORENSIC_ES_MRPN'] if 'FORENSIC_ES_MRPN' in os.environ else 10
DEEPDIVE_URL = os.getenv('DEEPDIVE_URL','')
DEEPDIVE_TOKEN = os.getenv('DEEPDIVE_TOKEN','')
DEEPDIVE_USER = os.getenv('DEEPDIVE_USER','')
DEEPDIVE_REPO  = os.getenv('DEEPDIVE_REPO','')
DIG_URL = os.getenv('DIG_URL','')
DW_CRAWL = os.getenv('DW_CRAWL', False)

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
