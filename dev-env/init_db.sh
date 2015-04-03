#!/bin/sh

echo "creating database tables"
cat build_db.sql | docker run -i --link devenv_dw_1:mysql --rm  mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" '

