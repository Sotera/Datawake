---
layout: page
title: Quick Start
permalink: /quick-start/
---

# Table of Contents

- [Introduction](#introduction)
- [	Installation utilizing the Demo Virtual Machine (Datawake VM)](#installation-utilizing-the-demo-virtual-machine-datawake-vm)
- [Installation utilizing an Amazon EC2 Instance)](#installation-utilizing-an-amazon-ec2-instance)
- [Running Datawake](#running-datawake)


# Introduction

This section describes the setup of the Datawake Demo on Windows, MacOS, and Linux operating systems.  The demo environment consists of six Docker containers that can be run within your native OS, within the Demo Virtual Machine using Virtual Box, or hosted on an Ubuntu 14.04 Server located on the EC2.  

The simplest local demo can be achieved utilizing the Demo Virtual Machine (VM).  It allows you to run a complete standalone Datawake instance consisting of Docker and the Datawake Docker Containers while using your host system’s Firefox and installed Datawake Firefox Plugin.  The VM requires very little setup aside from running the VM on your machine.  It should be noted that each time you restart the VM you will need to execute the perl script (mentioned later in this document) to start the Docker containers.  

Should you prefer a local installation the containers can be installed in your local Docker instance.  This may require some additional configuration within your environment as the Docker containers utilize several ports that may be in conflict with your host system (Ports 80, 3306, 3001,3002, etc.).   

Running Datawake requires that the user first Sign On using the Firefox Plugin, after which the Datawake Forensic Viewer is available at:  

    http://[localhost or machine IP Address]:8080/forensic  

The Datawake Manager uses a separate login and is available at:  

    http://[localhost or machine IP Address]:3002/
 ---

#	Installation utilizing the Demo Virtual Machine (Datawake VM)
There are a few prerequisites required to run Datawake in a VM on your machine.  These include the following:  

* Virtual Box  
* The “UbuntuSimpleDatwake” Demo Virtual Machine (a headless Ubuntu 14.04 server VM)  
* The Datawake Installation script (available via a public Amazon S3 share)  
* The Datawake Firefox “Plugin” Add-on (available via a public Amazon S3 share)  

## Installing Virtual Box and the Datawake Virtual Machine (Datawake VM)
Perform the following steps to install, configure, and start Datawake in the Demo VM.  
* Copy the two Datawake Demo Virtual Machine .vbox and .vdi files to a folder in your local VirtualBox VMs folder  
[Datawake VBOX](https://s3.amazonaws.com/soterastuff/simple_datawake/UbuntuSimpleDatawake/UbuntuSimpleDatawake.vbox)  
[Datawake VDI](https://s3.amazonaws.com/soterastuff/simple_datawake/UbuntuSimpleDatawake/UbuntuSimpleDatawake.vdi)  
* In VirtualBox select “Machine, Add” and browse to the location of the UbuntuSimpleDatawake.vbox file you just downloaded.  
* Start the VM. The user and password are “datawake”,”password”.   

The following steps need to be performed to install and configure the Datawake Docker Containers.
* Using VirtualBox, start the Linux virtual machine created in the previous section.
*	When it has booted up, hit Enter to get to a prompt.
*	Get the Datawake setup script  

```shell
$ wget https://s3.amazonaws.com/soterastuff/simple_datawake/datawake.pl  

Modify the file permissions to make it executable  

$ chmod 700 datawake.pl  

Execute the script  

 ./datawake.pl  
 ```  
*	Executing the script will install Docker on the VM.  When the script finishes, you need to log off the current user and log back in so Docker is usable.  
*	After logging off and back on, execute the script again to complete the Datawake installation.  This will download the Docker images, create the Datawake Containers, and start them.  This script is also used to start the Datawake containers whenever a VM is rebooted.  
``` shell
./datawake.pl
```  
*	After the Datawake content has downloaded, your containers should be running (you can verify by typing docker ps).  Keep in mind that each time you restart the VM you will need to execute the script again to start the Datawake Containers.  
``` shell
./datawake.pl
```  
*	Executing “docker ps” will show you all running Docker containers. When complete you should see the following six  containers:  
  *	data-container  
  *	mongo  
  * mysql  
  * loopback  
  * webapp  
  * tangelo  

## Installing the Firefox Plugin
*	Get the [Datawake Firefox “Plugin” Add-on](https://s3.amazonaws.com/soterastuff/simple_datawake/dwfirefox.xpi).   
* Double-click on the .xpi file that was downloaded and click install when prompted.
*	To manually install the Firefox Plugin:
  *	Open Firefox.
  * Click on the "Tools" menu.
  * Select "Add-ons".
  * Click on the Gear icon.
  * Select "Install Add-on from File".

---
# Installation utilizing an Amazon EC2 Instance
Though Docker can be configured to run on Mac and Windows it can require significant time and effort to configure and debug, hence the recommendation that it be run natively on Linux or via VirtualBox and the Datawake VM. In the case where you wish to share a Datawake Demo instance with team members you probably will not want to run the VM.  If you have an Amazon EC2 account you can easily set up a Datawake Demo stack there.    

There are a few prerequisites required to run Datawake on Amazon’s EC2 stack.  These include the following:  
*	An SSH client such as PuTTY (http://www.putty.org)  
*	An account with Amazon and the ability to set up EC2 Virtual Servers  
*	The Datawake Installation script (available via a public Amazon S3 share)  
*	The Datawake Demo Docker containers (available via DockerHub and installed via supplied script)  
*	The Datawake Firefox “Plugin” Add-on (available via a public Amazon S3 share)  

## Setting up & Configuring the EC2 Instance
Perform the following steps to install, configure, and start Datawake on an Amazon EC2 instance.
Configuring a base Ubuntu EC2 Server  

* On the Amazon Web Services page, click on EC2
*	In the middle of the page, click on the blue button for “Launch Instance”.
*	Select Ubuntu Server 14.04 LTS (HVM), SSD Volume Type
*	Choose an Instance Type and click Next.  
  *	There are numerous options to choose from here depending on the size and resources you wish to have available.  Some of these are free, while others involve fees.  The choice is largely up to you and your budget, but for a small team a micro instance should be sufficient to Demo Datawake.  
*	Leave the defaults on the next page, click  Next: Add Storage
  *	If you expect to create a large number or very long trails you may wish to increase the hard drive storage to 50+GB.
*	Leave the defaults on the next page, click  Next: Tag Instance
*	Provide an Instance Name and click Next.
*	Configure the Security Group.  Either create a new group or utilize an existing security group you have already set up. Then click Review and Launch
*	Review the summary page and Click Launch if everything is correct.
*	Click View Instances to monitor the status of the instance you have created.  Once it is provisioned and available you may proceed.

### Perform the following steps to install and configure Datawake and the Datawake Docker Containers on the new instance.  
*	Using the SSH client connect to the newly created Linux EC2 instance.  The IP Address is shown on the Instances page of the Amazon EC2 Console.  You may also need to configure your SSH/Terminal app to use your matching security key file when connecting.
*	Once connected Create the Datawake user by running the following commands:
``` shell
sudo useradd -m -d /home/datawake -N -G adm,cdrom,sudo,dip,plugdev -s /bin/bash datawake  
sudo passwd datawake  
(enter the word ‘password’ when prompted for the password)  
Switch users from Ubuntu to datawake  
$ su datawake  
$ cd ~  
Get the Datawake setup script  
$ wget https://s3.amazonaws.com/soterastuff/simple_datawake/datawake.pl  
Modify the file permissions to make it executable  
$ chmod 700 datawake.pl  
Execute the script  
$ ./datawake.pl  
```  
* Executing the script will install Docker on the VM.  
* When the script finishes, you need to log off the current user and log back in so Docker is usable.  
  * drop from the datawake user back to the Ubuntu account  
``` shell
CTRL+D  
su datawake  
```  
*	Execute the script again to complete the Datawake installation.  This will download the Docker images, create the Datawake Containers, and start them.  This script is also used to start the Datawake containers whenever a VM is rebooted.  
``` shell
cd ~  
./datawake.pl  
```  
*	After the Datawake content has downloaded, your containers will be started. Keep in mind that each time you restart the VM, you will need to execute the script again by typing “./datawake.pl” to start the Datawake Containers.  
*	Executing “docker ps” will show you all running Docker containers. When complete you should see the following six  containers:  
  * data-container  
  *	mongo  
  *	mysql  
  * loopback  
  *	webapp  
  *	tangelo  

## Installing the Firefox Plugin
*	Get the [Datawake Firefox “Plugin” Add-on](https://s3.amazonaws.com/soterastuff/simple_datawake/dwfirefox.xpi).   
* Double-click on the .xpi file that was downloaded and click install when prompted.
*	To manually install the Firefox Plugin:
  *	Open Firefox.
  * Click on the "Tools" menu.
  * Select "Add-ons".
  * Click on the Gear icon.
  * Select "Install Add-on from File".
  * Browse to the downloaded add-on.  Or simply double-click on the .xpi file that was downloaded and click install when prompted.  
*	You will need to change the default preferences for the Datawake Firefox Plugin to match your EC2 Instance Information.  To do so click the Firefox Open Menu button   and select Add-ons.
*	Under “Extensions” select “Options” for the Datawake Firefox Plugin.
*	Alter the Datawake Deployment Address to utilize your EC2 Instance’s IP Address by changing the word “localhost” to the EC2 IP (no port should be included in this URL)
*	Alter the Forensic View Deployment Address to utilize your EC2 Instance’s IP Address by changing the word “localhost” to the EC2 IP (no port should be included in this URL)
*	Alter the Datawake Deployment IP Address to utilize your EC2 Instance’s IP Address by changing the word “localhost” to the EC2 IP (no port should be included in this URL)
*	Set the Datawake Deployment Address PORT to 80
*	Close and re-open Firefox to insure that the plugin initializes these settings.  

---
# Running Datawake
To run Datawake your system or VM must have Docker and the Datawake Container installed and the six Docker containers must be running.  Once these conditions have been met, open your Firefox Browser.  
*	Click the Datawake Widget icon ![datawake-icon](img/waveicon16.png) in the top right corner of the Firefox browser.  
*	Click the “Sign in” button.  Once signed Datawake can start trailing your activity.    
*	Click the Datawake Widget button again. Select “CWhite” from the Team dropdown. Then select an existing Domain.  
*	You may pick an existing Trail or create a new one by clicking the “+” button and entering a Trail Name and Description.  
*	Click the “Start” button to begin tracking your activity.  Please note that after clicking Start ALL of your Firefox browser activity will be trailed.  
*	Click the blue “click for forensic trail viewer” button at the top left of the widget to view your trails in the Datawake Forensic Viewer.  Alternatively you can type ‘localhost:8080/forensic’ in the browser address bar to get to the Datawake Forensic page.  
*	The Datawake Manager page can be reached at ‘localhost:3002/login’  
Your Datawake Demo is now functional.


More detailed instructions on how to use Datawake are provided in the [Datawake User Guide](https://s3.amazonaws.com/soterastuff/Datawake_Demo/DW-USER-GUIDE.docx)

**Update-3**
