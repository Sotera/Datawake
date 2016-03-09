---
layout: page
title: Quick Start
permalink: /quick-start/
---

# Table of Contents
- [Introduction](#introduction)
- [Local Installation](#installation)

# Introduction <a id="introduction"></a>
Datawake consists of a [Node.js](https://nodejs.org/en/) Express application, a [Firefox](https://www.mozilla.org/en-US/firefox/new/) plugin, and a [mongoDB](https://www.mongodb.org/) database.  Additionally, it utilizes a StanfordNER extractor and [Page Rancor](https://github.com/Sotera/PageRancor).

_These instructions will assume that you have Docker running and that you are installing on a *nix based system._

# Local Docker-based Installation <a id="installation"></a>

This installation will set up 5 Docker containers which include:<br/>
*   sotera/datawake-rancor _(page ranking/prefetch server)_<br/>
*   sotera/datawake-stanner _(StanfordNER extractor)_<br/>
*   sotera/datawake-strongloop _(Datawake application)_<br/>
*   sotera/datawake-mongo _(Mongo)_<br/>
*   sotera/data-container _(Mongo Data Container)_<br/>

There are two ways of utilizing this setup.  The first is in a demo mode.  This is the default setup.  In demo mode, data is NOT persisted when the containers or system is restarted.  This works well for demo'ing the tool where you want a fresh setup each time.   The second mode is more a "production" mode.  In this setup data from trailing and configuration changes are persisted even when containers or the system is restarted.  YOU MUST RUN DATAWAKEDOCKER.SH THE FIRST TIME UNMODIFIED.  This is necessary to setup the data container itself.  However, after the first run, you can modify the shell script by commenting out certain lines as described in the file.  Then simply rerun the shell script and from that point forward data will be persisted to the local file system and be available after restarts.

Open a terminal

```
$ sudo gpasswd -a <currentuser> sudo
[log out, log in]
$ sudo apt-get update
$ wget -qO- https://get.docker.com/ | sh
$ sudo usermod -aG docker $(whoami)
[log out, log in]
$ wget https://raw.githubusercontent.com/Sotera/DatawakeDepot/develop/docker/datawakeDocker.sh
(Change the permissions to run it)
$ sudo chmod 700 datawakeDocker.sh
$ ./datawakeDocker.sh
```

Next we need to make some adjustments and rebuild the plugin

```
Shell into the datawake-strongloop container
$ docker exec –it <containerID> bash
$ cd svc/1/work/current/browser-plugins/firefox
Edit the index.js file
$ vi index.js
There will be 2 lines of interest:
  pluginState.pageModDatawakeDepotIncludeFilter = 'http://localhost:3001/*'; 
  pluginState.loginUrl = 'http://localhost:3001';
Change these to port 3000 instead of 3001
Save the file
From the same directory rebuild the plugin:
$ ./_runFF.sh
$ exit
```
  
The Datawake application is now running on [localhost:3000](http://localhost:3000). If you go to that page in Firefox, you will see a button on the bottom of the page "Get Datawake Plugin!". Click on this button and follow the Firefox prompts to install the plugin.  Once the plugin is installed, click the ‘Login’ button in the toolbar.  This opens a new login page, type the credentials below, and log in.

Username: admin@admin.com  
Password: admin  
