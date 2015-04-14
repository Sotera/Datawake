---
layout: page
title: Quick Start
permalink: /quick-start/
---

## Introduction ##
The Datawake demo environment consists of a Docker container that can be run within your native OS or within the Demo Virtual Machine using Virtual Box. 
  <br />  
  <br />  
  
## Installation Types ##
### Preconfigured Virtual Machine ###

The simplest demo environment setup can be achieved utilizing the Demo Virtual Machine (VM).  It will allow you to run a complete standalone Datawake instance consisting of Docker, the Datawake Docker Container and Firefox with the installed Datawake plugin.  The VM requires virtually no setup aside from running the VM on your machine.  It should be noted that data tracked will not be permanently persisted to the VM, that is each time you restart the VM or Docker you will be working only with the pre-loaded demo data in the VM.

**Files Needed:** <br />
[VirtualBox Installation Files](https://www.virtualbox.org/wiki/Downloads "Download & Install VirtualBox") <br />
[Demo Virtual Machine Image](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DataWakeDemoVM.zip "Zipped VM Files") <br />
[Docker Startup Script for Datawake](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dockerstartup.sh "Docker Startup File") <br />

  <br />
### Docker & Docker Container ###
Should you wish to have a local installation that doesn't require the use of a VM, the Docker container can be installed within your local Docker instance.  This may require some additional configuration within your environment, as the Docker container’s webserver uses port 80. 

**Files Needed:** <br />
[Docker Application](https://docs.docker.com/installation/#installation "Docker Installation Info & Files") <br />
[Demo Docker Container](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dw_demo.tar "Tarfile for Docker Container") <br />
[Docker Environment Variables](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DWenvVar.txt "Docker Environment Variables") <br />
[Docker Startup Script for Datawake](https://s3.amazonaws.com/soterastuff/Datawake_Demo/dockerstartup.sh "Docker Startup File") <br />

_Additional Installation Instructions can be found [here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/Datawake-Demo-InstallationGuide.docx "Datawake Demo Installation Guide")_ <br />
_The Datawake User's Guide is located  [here](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DW-USER-GUIDE.docx "Datawake User's Guide")_
