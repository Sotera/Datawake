---
layout: page
title: Quick Start
permalink: /quick-start/
---

## Introduction

The Datawake demo environment consists of a Docker container that can be
run within your native OS or within the Demo Virtual Machine using
Virtual Box.  

## Installation Types

# Preconfigured Virtual Machine

The simplest demo environment setup can be achieved utilizing the Demo
Virtual Machine (VM). It will allow you to run a complete standalone
Datawake instance consisting of Docker, the Datawake Docker Container
and Firefox with the installed Datawake plugin. The VM requires
virtually no setup aside from running the VM on your machine. It should
be noted that data tracked will not be permanently persisted to the VM,
that is each time you restart the VM or Docker you will be working only
with the pre-loaded demo data in the VM.

Files Needed:  
[VirtualBox Installation
Files](https://www.virtualbox.org/wiki/Downloads "Download & Install VirtualBox")  
[Demo Virtual Machine
Image](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DataWakeDemoVM.zip "Zipped VM Files")  
[Docker Startup Script for
Datawake](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dockerstartup.sh "Docker Startup File")  

### Instructions

1.  Download and install the [Virtual Box](https://www.virtualbox.org/wiki/Downloads)  
1.  Download the [Datawake Demo VM](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DataWakeDemoVM.zip)  
1.  In Virtual Box, select “Machine, Add” and browse to the location of DataWakeDemoVM.vbox downloaded in the previous step.
1.  Start the VM.
  * The user and password are “demo”,”demo”
1.  Double-click the “MATE Terminal” icon
1.  In the terminal, type ‘sudo /opt/dockerstartup.sh’ and click Enter
  * You will be prompted for the password. Enter 'demo' and click enter.
1.  Start Firefox

If you trying to use Firefox outside of the VM and are having problems with the plugin logging in, you may need to change your VM network settings to "bridged" mode so the VM and your PC are on the same network.  Using Firefox within the VM should not have this issue.


# Docker & Docker Container

Should you wish to have a local installation that doesn't require the
use of a VM, the Docker container can be installed within your local
Docker instance. This may require some additional configuration within
your environment, as the Docker container’s webserver uses port 80.  

Files Needed:  
[Docker
Application](https://docs.docker.com/installation/#installation "Docker Installation Info & Files")
[Demo Docker
Container](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dw_demo.tar "Tarfile for Docker Container")  
[Docker Environment
Variables](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DWenvVar.txt "Docker Environment Variables")  
[Docker Startup Script for
Datawake](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dockerstartup.sh "Docker Startup File")  
[Datawake Firefox Plugin](https://s3.amazonaws.com/soterastuff/Datawake_Demo/datawakefirefoxaddon.xpi)  


### Instructions
1.	Download and install the [Docker software](https://docs.docker.com/) for your operating system.
1.	Download the [Datawake Demo Container](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dw_demo.tar) and [start file](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dockerstartup.sh) (dw_demo.tar and dockerstartup.sh).
1.	Type ‘sudo docker load < dw_demo.tar’  to load the image.
1.	Type ‘sudo docker run -d -p 0.0.0.0:80:80 -it --name "datawake_demo" dw_demo bash’ to create the Datawake Demo Container from the image you loaded
1.	Type ‘sudo dockerstartup.sh’ to execute the Docker container via the shell script.  
  * This will startup the Tangelo web server and the MySQL database instance.
1. Within boot2docker type 'ifconfig' to find your IP (this is likely 192.168.59.103).  You will need this to configure the Firefox plugin.
1.	Download the [Firefox addon](https://s3.amazonaws.com/soterastuff/Datawake_Demo/datawakefirefoxaddon.xpi) (datawakefirefoxaddon.xpi)
1.  Install the addon in Firefox using the Firefox Menu, Add-ons, Install Add-on from File option.
1.  In the Firefox Menu, Add-ons, click on the Datawake Extension 'Options'.  Here, replace the IP addresses listed to reflect the IP address you got in the steps above for boot2docker.  Restart Firefox.
1.	To stop/startup the Datawake instance after the initial run, type the following commands:
  *	sudo docker stop datawake_demo
  *	sudo ./dockerstartup.sh


## Using DataWake
1.	Click the Datawake Widget in the top right corner of the Firefox browser.
1.	Click the “Sign in” button.  
1.	Click the Datawake Widget button again. Select the “CWhite” from the Team dropdown, then select an existing Domain.  
1.	You may pick an existing Trail or create a new one by clicking the “+” button and entering a Trail Name and Description.
1.	Click the “Start” button to begin tracking.
1.	Click the blue “click for forensic trail viewer” button to see your trails in the Forensic Viewer.
1.	Your Datawake Demo VM is now functional.


*Additional Installation Instructions can be found
[here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/Datawake-Demo-InstallationGuide.docx "Datawake Demo Installation Guide")*
<br /> *The Datawake User's Guide is located
[here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DW-USER-GUIDE.docx "Datawake User's Guide")*
