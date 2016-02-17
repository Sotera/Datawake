---
layout: page
title: Quick Start
permalink: /quick-start/
---

# Table of Contents
- [Introduction](#introduction)
- [Local Installation](#installation)
- [Docker-based Installation](#docker)
- [Development Installation](#devinstallation)

# Introduction <a id="introduction"></a>
Datawake consists of a [Node.js](https://nodejs.org/en/) Express application, a [Firefox](https://www.mozilla.org/en-US/firefox/new/) plugin, and a [mongoDB](https://www.mongodb.org/) database.

_These instruction will assume that you have mongoDB running locally on port 27017 and that you are installing on a *nix based system._

# Local Installation <a id="installation"></a>
Open a terminal

```
$ wget https://github.com/jreeme/firmament/raw/master/install-scripts/prep-ubuntu14.04.sh
(Change the permissions to run it)
$ sudo chmod 700 prep-ubuntu14.04.sh
(Add all necessary prereqs to the system)
$ sudo su
$ ./prep_ubuntu14.04.sh
$ exit
$ sudo npm install -g jpm 
(create a ~/src directory and change to it)
$ git clone https://github.com/Sotera/DatawakeDepot.git  
$ cd DatawakeDepot  
$ npm install
$ lb-ng server/server.js client/app/js/lb-services.js
$ cd browser-plugins/firefox/  
$ ./_runFF.sh  
$ cd ../..  
$ nohup node server/server.js  
```
  
The Datawake application is now running on [localhost:3000](http://localhost:3000). If you go to that page in Firefox, you will see a button on the bottom of the page "Get Datawake Plugin!". Click on this button and follow the Firefox prompts to install the plugin.  Once the plugin is installed, click the ‘Login’ button in the toolbar.  This opens a new login page, type the credentials below, and log in.

Username: admin@admin.com  
Password: admin  

# Docker-based Datawake Installation <a id="docker"></a>
This installation can work on any system where you have Docker installed and available.  However, it is recommended that this be run on a dedicated Ubuntu 14.04 system.  This can be anything from a local VM to an EC2 instance, local VM install being the easiest option.  Since the host operating system and its configuration options are varied, we will proceed with instructions for installing on Ubuntu.  You may adapt the process as desired if deploying to other operating systems.

On the Ubuntu system, open a terminal window and perform the following:

```
~$ wget https://github.com/jreeme/firmament/raw/master/install-scripts/prep-ubuntu14.04.sh

We need to change the permissions on this file to run it

~$ sudo chmod 700 prep-ubuntu14.04.sh

Now we add all necessary pre-reqs to the system

~$ sudo su
/home/<ubuntu-user>#  ./prep_ubuntu14.04.sh
/home/<ubuntu-user># exit 
```

Next we’ll install a deployment tool called Firmament.  Firmament downloads or builds the necessary Docker containers, exposes the necessary ports, kicks off the applications and various other tasks.

```
~$ git clone https://github.com/Sotera/firmament
~$ cd firmament/install-scripts
~$./prep-client.sh
~$ sudo su 
/home/<ubuntu-user># usermod –aG docker ubuntu
~$ exit

close terminal and reopen to detect the changes made

~$ cd firmament
~/firmament$ f init

This installs any missing dependencies Firmament needs to continue

~/firmament$ f m b SUG-spr2016.json

This will build the necessary Docker containers for the project, checkout, build & configure them, 
and start them up.  If for some reason the build process reports something went wrong…simply rerun
the last step.  When complete, running ‘docker ps –a’ should show two containers running.
```

Restarting Containers
The Docker containers will not automatically start up on system reboot.  You can either start them manually, or utilize a startup process manager.  For Ubuntu 14.04 you can use Upstart.  You will need to create two files (as root) in the /etc/init directory.  These files can be named whatever you like but must end in .conf.  I’d suggest datawake.conf and dw-mongo.conf.  Their contents should look like the following.

```
Datawake.conf:
description “Datawake container"
author “Me”
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  /usr/bin/docker start -a datawake-depot
end script

dw-mongo.conf:
description “DW Mongo container"
author “Me”
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  /usr/bin/docker start -a datawake-depot/mongo
end script
```

The Datawake server is now running on localhost:3001. If you go to that page in Firefox, you will see a button on the bottom of the page “Get Datawake Plugin!”. Click on this button and follow the Firefox prompts to install the plugin.  Once the plugin is installed, click the ‘Login’ button in the toolbar.  This opens a new login page, type the credentials below, and log in.

Username: admin@admin.com
Password: admin


# Development Installation <a id="devinstallation"></a>
<span>__Download VM from S3 and Install in Virtualbox__</span>
 
The Dev VM is located on the Sotera Datawake [Amazon S3](https://console.aws.amazon.com/s3/home?region=us-east-1&bucket=soterastuff&prefix=Datawake_Dev/).  The file is called _NovDevVM.tar.gz_.  Unzip this file to your Virtualbox VMs directory wherever you configured it when you set up Virtualbox.  This should create a ‘_UbuntuDev-August_’ folder.  Launch Virtualbox and choose Add from the Machine menu.  Point it to the vbox file in the folder we just created.  Now you should be able to start the VM.  Login into Ubuntu using the ‘_Datawake Dev Acct_’  and ‘_password_’ for the password.
 
__Updating the Datawake Depot Files__
 
Open Terminal from the desktop.  We’ll need to make sure Mongo is running, so type: ‘_sudo /etc/init.d/mongodb start_’ then hit enter.  You will be prompted to supply the password for the sudo user.  Type ‘_password_’ and hit enter.  You should see an “_OK_” message regarding the startup state of Mongo.
 
Next, navigate to ‘_/src/DatawakeDepot_’ and type: ‘_git pull_’.  This will pull down the latest DatawakeDepot code from Github.  Then type: ‘_npm install_’.  This will take a little bit of time as npm installs and configures the necessary components.  Finally, type: ‘_lb-ng server/server.js client/app/js/lb-services.js_’.  This should finish rather quickly compared to the other commands.  Once you’re back at a system prompt, you can close the terminal and move on.
 
__Running Datawake__
 
Launch Webstorm from the Applications location or the icon in the upper toolbar of Ubuntu.  Once Webstorm starts up, it will likely take a few minutes indexing the files.  When the Green “bug” icon in the top right of the toolbar will light up, click on this and it should start the server and launch your browser taking you to the Depot login page.  Use ‘_admin@admin.com_’ as the user and ‘_admin_’ as the password, then click _Login_.  You’re all set now.
 
To work with Trails, you will need to run from Firefox (so you have access to the toolbar plugin).  To get to the Depot page in Firefox, simply type _http://localhost:3000_ in the address bar and hit enter.  If the toolbar is already installed, you can click on the _Login_ button in the toolbar plugin instead, and this will take you to the login page for Datawake Depot.  If the toolbar is not already installed you can install it via the "Get Datawake Plugin" button at the bottom of the login page dialog.  Click on this button and follow the Firefox prompts to install the plugin.  Once the plugin is installed, click the ‘Login’ button in the toolbar.  This opens a new login page, type the credentials below, and log in.

Username: admin@admin.com
Password: admin

