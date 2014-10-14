# ATG CRS 11.1 on AWS Guide

## About

This project gives you a quick and easy way to stand up an ATG CRS 11.1 server on Amazon AWS.  This is good for demos and just for playing around with a running instance.  If you have a laptop that can run the ATG CRS locally, you can use the [Vagrant-CRS project](https://github.com/kpath/Vagrant-CRS) instead.  

If you get lost, you can consult the [ATG CRS Installation and Configuration Guide](http://docs.oracle.com/cd/E52191_01/CRS.11-1/ATGCRSInstall/html) for help.

## Assumptions

This project assumes the following:

- You have access to an AWS account and the rights to provision new instances
  - If you don't have this access, you won't be able to get an access key id for provisioning
- You've created a security group that will allow ssh access from your machine to the provisioned instance.  By default instances do not allow ssh access.
  - If you haven't created this group, then ssh access to your provisioned instance will never become available.
- You've gathered all of the required software installers listed in [Appendix A](https://github.com/kpath/Vagrant-CRS-AWS#appendix-a---where-to-get-required-software) and put them onto and EBS volume and created a snapshot of said volume
  - If you haven't prepared this volume, the provisioning scripts will fail

## Setup

Step one is to create a file called `env.sh` and put it in the top level directory of this project.  In it you'll put private login and account information that's required to make this project go.

```
export VAGRANT_DEFAULT_PROVIDER=aws
export AWS_ACCESS_KEY_ID=<your access key id>
export AWS_SECRET_ACCESS_KEY=<your secret key>
export AWS_PRIVATE_KEY_PATH=</full/path/to/your/key.pem>
export AWS_KEYPAIR_NAME=<your keypair name>
export AWS_SECURITY_GROUP=<security group that allows ssh access>
export AWS_SOFTWARE_SNAPSHOT=<EBS volume snapshot that contains software installers>
```

All of this AWS-related information comes from your AWS account and you get it by logging in to your AWS account.  You create an access key with a AWS_ACCESS_KEY_ID and a AWS_SECRET_ACCESS_KEY using [Amazon IAM](https://console.aws.amazon.com/iam/home?#users) and clicking on your username.  If you've lost or forgotten your secret key, you need to generate another key.  You only get to see it once.  Get or create a keypair by going to the EC2 management console and navigating to `Key Pairs` on the left.  Download the .pem file and set AWS_PRIVATE_KEY_PATH to be the full path to that file on your local computer.  Set AWS_KEYPAIR_NAME to the name you gave it in the EC2 console.

## Install Vagrant

Get and install [Vagrant](http://www.vagrantup.com/downloads.html).

## Install vagrant-aws plugin

`vagrant plugin install vagrant-aws`

## Provision

Open a shell and navigate to the top level directory of this project.  First you have to source your env.sh file to get the required environment variables:

`. env.sh`

Then launch the instance and provision it with:

`vagrant up`

**NOTE:** if you don't put the line `VAGRANT_DEFAULT_PROVIDER=aws` in your env.sh file, you'll get an error here.  You either have to put that line in your env.sh file and source it again, or you have to specify what provider you're using in the command: `vagrant up --provider aws`

This step can take a long time.  It's setting up an Oracle DB, Endeca and Publishing and Production ATG servers.

## How to log in as the vagrant user

If you haven't already, don't forget to source your environment variables:

`. env.sh`

When it finally finishes, you can ssh to the box:

`vagrant ssh`

You'll be logged in to the AWS instance as root.  Change to the vagrant user by typing

`su - vagrant`

The box is set up to run everything on startup and to restart everything if you bring the instance down and bring it back up.  Give the services some time to come up.  It takes a minute or two to start both of the ATG jboss servers.

## Run initial full deployment

At this point, you can pick up the ATG CRS documentation from the [Configuring and Running a Full Deployment](http://docs.oracle.com/cd/E52191_01/CRS.11-1/ATGCRSInstall/html/s0214configuringandrunningafulldeploy01.html) section.  Your publishing server has all the CRS data, but nothing has been deployed to production.  You need to:

- Deploy the crs data
- Check the Endeca baseline index status
- Promote the CRS content from the command line

### Deploy the CRS data

Do this from within the BCC by following the [docs](http://docs.oracle.com/cd/E52191_01/CRS.11-1/ATGCRSInstall/html/s0214configuringthedeploymenttopology01.html)

### Check the baseline index status

Do this from within the Dynamo Admin by following the [docs](http://docs.oracle.com/cd/E52191_01/CRS.11-1/ATGCRSInstall/html/s0215checkingthebaselineindexstatus01.html)

### Promote the endeca content

Do this from the command line from within the vm.  Ssh to the instance and su to vagrant (see [How to log in as the vagrant user](https://github.com/kpath/Vagrant-CRS-AWS#log-in-as-the-vagrant-user)) and then type:

`/usr/local/endeca/Apps/CRS/control/promote_content.sh`

## Getting your instance's public IP

You can always go to the EC2 dashboard to look up your instance's public ip.  If you want to do it from the command line, you can use the vagrant-awsinfo plugin to look it up: 

`vagrant plugin install vagrant-awsinfo`

## Access the storefront

The CRS application is live at: 

`http://<your AWS public ip or address>:8080/crs`

## Additional Info

After you've got the instance running and provisioned, and you've successfully visited the crs storefront, you might find the following info useful

- ATG admin username/password: admin/Admin123
- Experience Manager username/password: admin/admin
- Oracle system username/password: system/oracle
- Oracle ATG schema username/passwords: crs_pub,crs_core,crs_cata,crs_catb - passwords same as username
- The production server is running on all the default jboss ports, which means HTTP on 8080.  
- The publshing server is running on all ports +100, which means HTTP 8180

## Controlling Services

Remember, to log in to your AWS intance as root, you do:

`vagrant ssh`

This works because your environment variable specified where your aws .pem key is, so now vagrant knows where it is too and you can use it to access your aws box.

```
service dbora start/stop
service endecaplatform start/stop
service endecaworkbench start/stop
service endecacas start/stop
service atgpublishing start/stop
service atgproduction start/stop
```

on your local machine, you can stop/start the aws instance:

```
vagrant halt
vagrant up
```

if you're sure you're done with the instance:

`vagrant destroy`

**CAUTION!** once it's destroyed, it's done for good.  This process does not destroy the volume with the installers on it, however, so you don't have to worry about that.

## Appendix A - Where to get required software

This section gives instructions on where to get the software installers used by this project.  When you're done, you should have an EBS drive that contains the following files inside the root directory:


```
/
├── OCPlatform11.1.bin
├── OCReferenceStore11.1.bin
├── OCcas11.1.0-Linux64.sh
├── OCmdex6.5.1-Linux64_829811.sh
├── OCplatformservices11.1.0-Linux64.bin
├── V46389-01.zip
├── jboss-eap-6.1.0.zip
├── jdk-7u67-linux-x64.rpm
├── ojdbc7.jar
├── p13390677_112040_Linux-x86-64_1of7.zip
├── p13390677_112040_Linux-x86-64_2of7.zip
```

### Oracle 11g (11.2.0.4.0) Enterprise Edition

- Go to [Oracle Support](http://support.oracle.com)
- Click the "patches and updates" tab
- On the left of the page look for "patching quick links". If it's not expanded, expand it.
- Within that tab, under "Oracle Server and Tools", click "Latest Patchsets"
- This should bring up a popup window.  Mouse over Product->Oracle Database->Linux x86-64 and click on 11.2.0.4.0
- At the bottom of that page, click the link "13390677" within the table, which is the patch number
- Only download parts 1 and 2.

Even though it says it's a patchset, it's actually a full product installer.  

### ATG 11.1

- Go to [Oracle Edelivery](http://edelivery.oracle.com)
- Accept the restrictions
- On the search page Select the following options: 
  - Product Pack -> ATG Web Commerce
  - Platform -> Linux x86-64
- Click Go
- Click the top search result "Oracle Commerce (11.1.0), Linux"
- Download the following parts:
  - Oracle Commerce Platform 11.1 for UNIX
  - Oracle Commerce Reference Store 11.1 for UNIX
  - Oracle Commerce MDEX Engine 6.5.1 for Linux
  - Oracle Commerce Content Acquisition System 11.1 for Linux
  - Oracle Commerce Experience Manager Tools and Frameworks 11.1 for Linux
  - Oracle Commerce Guided Search Platform Services 11.1 for Linux

**NOTE**  The Experience Manager Tools and Frameworks is a zipfile labeled `V46389-01.zip`

### JDK 1.7

- Go to the [Oracle JDK 7 Downloads Page](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
- Download "jdk-7u67-linux-x64.rpm"

### JBoss EAP 6.1

- Go to the [JBoss product downloads page](http://www.jboss.org/products/eap/download/)
- Click "View older downloads"
- Click on the zip downloader for 6.1.0.GA

### OJDBC Driver

- Go to the [Oracle 12c driver downloads page](http://www.oracle.com/technetwork/database/features/jdbc/jdbc-drivers-12c-download-1958347.html)
- Download ojdbc7.jar

All oracle drivers are backwards compatible with the officially supported database versions at the time of the driver's release.  You can use ojdbc7 to connect to either 12c or 11g databases.


