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

1.  Download and install the Virtual Box version pertaining to your
    operating system from https://www.virtualbox.org/wiki/Downloads
1.  Copy the Datawake Demo Virtual Machine to your preferred location
1.  Select “Machine, Add” and browse to the location of your copy of the
    VM. Select the DataWakeDemoVM.vbox file.
1.  Start the VM, the user and password are “demo”,”demo”
1.  Double-click the “MATE Terminal” icon o Type ‘sudo
    /opt/dockerstartup.sh’ and click Enter, you will be prompted for the
    demo password
1.  Start Firefox


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
1.	Download the [Firefox addon](https://s3.amazonaws.com/soterastuff/Datawake_Demo/datawakefirefoxaddon.xpi) (datawakefirefoxaddon.xpi)
1.  Install the addon in Firefox using the Firefox Menu, Add-ons, Install Add-on from File option.

## Using DataWake
1.	Click the Datawake Widget in the top right corner of the Firefox browser.
1.	Click the “Sign in” button.
1.	Click the Datawake Widget button again. Select the “CWhite” from the Team dropdown, then select an existing Domain.  
1.	You may pick an existing Trail or create a new one by clicking the “+” button and entering a Trail Name and Description.
1.	Click the “Start” button to begin tracking.
1.	Click the blue “click for forensic trail viewer” button to see your trails in the Forensic Viewer.
1.	Your Datawake Demo VM is now functional.
1.	To stop/startup the Datawake instance after the initial run, type the following commands:
  *	sudo docker stop datawake_demo
  *	sudo ./dockerstartup.sh


*Additional Installation Instructions can be found
[here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/Datawake-Demo-InstallationGuide.docx "Datawake Demo Installation Guide")*
<br /> *The Datawake User's Guide is located
[here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DW-USER-GUIDE.docx "Datawake User's Guide")*
