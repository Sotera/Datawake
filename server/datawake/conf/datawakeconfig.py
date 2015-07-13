import os
from datawake.util.db import datawake_mysql as db

"""
All configuration for the datawake web server.
To change the configuration you should set the appropriate environment variables.
Environment variables are used to set conf to conform to standard docker practices.

OPTIONAL ENVIRONMENT VARIABLES

DW_GOOGLE_CLIENT_IDS: list of client ids used for google user authentication
DW_MOCK_AUTH:  If set actual user authentication is bypassed for browser plugins. (for dev / demos only)
DW_MOCK_FORENSIC_AUTH:  If set actual user authentication is bypassed for forensic views. (for dev / demos only)

ES_URL: url for forensic view elastic search
ES_INDEX: the index to search, defaults to none (all indexes)
ES_CRED:  username:password for elastic search
ES_MRPN: max elastic search results to return per node
"""

VERSION_NUMBER="0.7-SNAPSHOT"
def get_es_url():
    return db.getSetting('ES_URL')
def get_es_index():
    return db.getSetting('ES_INDEX')
def get_es_cred():
    return db.getSetting('ES_CRED')
def get_es_mrpn():
    return db.getSetting('ES_MRPN')
def get_deepdive_url():
    return db.getSetting('DEEPDIVE_URL')
def get_deepdive_token():
    return db.getSetting('DEEPDIVE_TOKEN')
def get_deepdive_user():
    return db.getSetting('DEEPDIVE_USER')
def get_deepdive_repo():
    return db.getSetting('DEEPDIVE_REPO')
def get_dig_url():
    return db.getSetting('DIG_URL')
def crawl():
    return db.getSetting('DW_CRAWL', False)

# read optional params

def get_client_ids():
    client_ids = db.getSetting('DW_GOOGLE_CLIENT_IDS')
    if client_ids:
        return client_ids.strip().split(',')
    else:
         return []

def get_mock_auth():
    return db.getSetting('DW_MOCK_AUTH')
def get_mock_forensic_auth():
    return db.getSetting('DW_MOCK_FORENSIC_AUTH')

def get_entity_connection():
    ENTITY_CONNECTION = 'mysql'
    dw_conn_type = db.getSetting('DW_CONN_TYPE')
    if dw_conn_type:
        ENTITY_CONNECTION = dw_conn_type.lower()
    if ENTITY_CONNECTION != 'mysql' and ENTITY_CONNECTION != 'cluster-impala' and ENTITY_CONNECTION != 'cluster-hbase':
        raise ValueError("DW_CONN_TYPE must be 'mysql' or 'cluster-impala', or 'cluster-hbase' if set. ")
    return ENTITY_CONNECTION


# can be "cluster" or "mysql"

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
