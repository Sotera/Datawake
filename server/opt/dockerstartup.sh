#!/bin/sh

echo "Starting up the container"
docker start datawake_demo

echo "Startup mysql and tangelo"
docker exec -d -it datawake_demo sh -c '/etc/init.d/mysql start;/usr/local/bin/tangelo -c /etc/tangelo.conf'

