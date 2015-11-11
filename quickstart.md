---
layout: page
title: Quick Start
permalink: /quick-start/
---

# Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)

# Introduction
DataWake consists of a [Node.js](https://nodejs.org/en/) Express application, a [Firefox](https://www.mozilla.org/en-US/firefox/new/) plugin, and a [mongoDB](https://www.mongodb.org/) database.

_These instruction will assume that you have, Git, Node.js installed, mongoDB running locally on port 27017 and that you are installing on a *nix based system._

# Installation
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
