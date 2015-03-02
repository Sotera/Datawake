docker-build
==============

Dockerfile and conf files to build a Datawake docker container.  Prior to running conf files within the container must be updated to point to required services such as mysql,kafka,etc.


### Pre-reqs

1. virtual box
2. docker
3. boot2docker (if not running on linux, see docker install guide)
4. fig


### Dev-environments on non - Linux systems  (Windows or OSX)

Docker runs on linux and requires specific kernel features, so to run in OSX we actually run docker in a VM called boot2docker.  If you are running on windows or linux be sure to follow the docker setup instructions to install and use boot2docker as well.

NOTE:  boot2docker should automatically allow you to link volumes from your user directory into the VM.  If you are adding volumes they must be in your User directory.
WARNING:  A current issue with boot2docker on OSX prevents us from writing to mounted directories from within containers.  This prevents us from persisting data outside of containers.


###  Seting up a dev environment.

The dev environment consists of several isolated docker containers that make up the various components of the application.

1.  mysql 
2. tangelo web server

For an easy dev environment we use fig to set up and deploy the docker containers.

Edit dev-env/fig.yml.template

1. Under datawake edit the volumes for the location of code in your user directory. This allows you to edit code on your machine for development without having to rebuild containers for changes to be deployed. 
2. Rename to fig.yml



(LINUX ONLY) To persist data edit across mysql containers edit fig.yml to mount a volume for the mysql container.  
WILL NOT CURRENTLY WORK USING BOOT2DOCKER  on OSX (https://github.com/boot2docker/boot2docker/issues/581) due to a problem with write permissions.
```
mysql:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD: root
  ports:
    - "3336:3306"
  volumes:
    - /Users/.../data/docker/mysql:/var/lib/mysql
```

Launch containers and configure the app

```

# move to the docker-build direcotry
cd dev-env

# download and build containers
fig up -d

# list the running docker containers to make sure everything worked
# you should see 5 containers, datawake,dwstream,kafka,zookeeper, and mysql
docker ps


# if needed set up the initial database, and create a mock user
./init_db.sh   


```



useful docker snippets
===============

```
# connect to the mysql terminal
docker run -it --link  devenv_mysql_1:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

```
