import os
"""
DW_DB: database name
DW_DB_USER: database username
DW_DB_PASSWORD: database password
DW_DB_HOST: database ip address or hostname
DW_DB_PORT: database port
"""

DATAWAKE_CORE_DB = {
    'database': os.getenv('DW_DB','memex_sotera'),
    'user': os.getenv('DW_DB_USER','root'),
    'password':os.getenv('DW_DB_PASSWORD','root'),
    'host': os.getenv('MYSQL_PORT_3306_TCP_ADDR','localhost'),
    'port': os.getenv('MYSQL_PORT_3306_TCP_PORT','3306')
}

LOOPBACK_PORT_3001_TCP_ADDR = os.getenv('LOOPBACK_PORT_3001_TCP_ADDR','localhost')
LOOPBACK_PORT_3001_TCP_PORT = os.getenv('LOOPBACK_PORT_3001_TCP_PORT','3001')
