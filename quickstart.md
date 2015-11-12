---
layout: page
title: Quick Start
permalink: /quick-start/
---

# Table of Contents
- [Introduction](#introduction)
- [Local Installation](#installation)
- [Development Installation](#devinstallation)

# Introduction <a id="introduction">
DataWake consists of a [Node.js](https://nodejs.org/en/) Express application, a [Firefox](https://www.mozilla.org/en-US/firefox/new/) plugin, and a [mongoDB](https://www.mongodb.org/) database.

_These instruction will assume that you have, Git, Node.js installed, mongoDB running locally on port 27017 and that you are installing on a *nix based system._

# Local Installation <a id="installation">
Open a terminal

```bash
$ npm install -g bower grunt  
$ git clone https://github.com/Sotera/DatawakeDepot.git  
$ cd DatawakeDepot  
$ npm install  
$ grunt build --force  
$ grunt build --force  
$ cd browser-plugins/firefox/  
$ ./_runFF.sh  
$ cd ../..  
$ node server/server.js  
```
  
The DataWake application is now running on [localhost:3000](http://localhost:3000). If you go to that page in Firefox, you will see a button on the bottom of the page "Get Datawake Plugin!". Click on this button and follow the Firfox prompts to install the plugin.

You are now able to login to the application using credentials:  
Username: admin@admin.com  
Password: admin  

# Development Installation <a id="devinstallation">
### Download VM from S3 and Install in Virtualbox
 
The link Dev VM is located at ‘_https://console.aws.amazon.com/s3/home?region=us-east-1&bucket=soterastuff&prefix=Datawake_Dev/_ ’.  The file is called _NovDevVM.tar.gz_.  Unzip this file to your Virtualbox VMs directory wherever you configured it when you set up Virtualbox.  This should create a ‘_UbuntuDev-August_’ folder.  Launch Virtualbox and choose Add from the Machine menu.  Point it to the vbox file in the folder we just created.  Now you should be able to start the VM.  Login into Ubuntu using the ‘_Datawake Dev Acct_’  and ‘_password_’ for the password.
 
### Updating the Datawake Depot Files
 
Open Terminal from the desktop.  We’ll need to make sure Mongo is running, so type: ‘_sudo /etc/init.d/mongodb start_’ then hit enter.  You will be prompted to supply the password for the sudo user.  Type ‘_password_’ and hit enter.  You should see an “_OK_” message regarding the startup state of Mongo.
 
Next, navigate to ‘_/src/DatawakeDepot_’ and type: ‘_git pull_’.  This will pull down the latest DatawakeDepot code from Github.  Then type: ‘_npm install_’.  This will take a little bit of time as npm installs and configures the necessary components.  Once it’s done, type: ‘_grunt build --force_’.  This will build the Datawake components and their dependencies.  The process takes a minute or so.  Finally, type: ‘_lb-ng server/server.js client/app/js/lb-services.js_’.  This should finish rather quickly compared to the other commands.  Once you’re back at a system prompt, you can close the terminal and move on.
 
### Running Datawake
 
Launch Webstorm from the Applications location or the icon in the upper toolbar of Ubuntu.  Once Webstorm starts up, it will likely take a few minutes indexing the files.  When the Green “bug” icon in the top right of the toolbar will light up, click on this and it should start the server and launch your browser taking you to the Depot login page.  Use ‘_admin@admin.com_’ as the user and ‘_admin_’ as the password, then click _Login_.  You’re all set now.
 
To work with Trails, you will need to run from Firefox (so you have access to the toolbar plugin).  To get to the Depot page in Firefox, simply type ‘_http://localhost:3000/#/login_’ in the address bar and hit enter.  If the toolbar is already installed, you can click on the _Login_ button in the toolbar plugin instead, and this will take you to the login page for Datawake Depot.
