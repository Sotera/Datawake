import os

# REQUIRED_PARAMS = [
#     'DW_DB',
#     'DW_DB_USER',
#     'DW_DB_PASSWORD',
#     # 'DW_DB_HOST',
#     # 'DW_DB_PORT',
# ]
# not_found = []
# for param in REQUIRED_PARAMS:
#     if param not in os.environ:
#         not_found.append(param)
# if len(not_found) > 0:
#     raise ValueError("Datawake required environment variables not set: "+str(not_found))

DATAWAKE_CORE_DB = {
    'database': os.getenv('DW_DB','memex_sotera'),
    'user': os.getenv('DW_DB_USER','root'),
    'password':os.getenv('DW_DB_PASSWORD','root'),
    'host': os.getenv('MYSQL_PORT_3306_TCP_ADDR','localhost'),
    'port': os.getenv('MYSQL_PORT_3306_TCP_PORT','3306')
}

LOOPBACK_PORT_3001_TCP_ADDR = os.getenv('LOOPBACK_PORT_3001_TCP_ADDR','localhost')
LOOPBACK_PORT_3001_TCP_PORT = os.getenv('LOOPBACK_PORT_3001_TCP_PORT','3001')
