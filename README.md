# ATG CRS 11.1 on AWS Guide

## About

This project gives you a quick and easy way to stand up an ATG CRS 11.1 server on Amazon AWS.  This is good for demos and just for playing around with a running instance.  If you have a laptop that can run the ATG CRS locally, you can use the [Turnkey project](https://github.com/grahammather/ATG-CRS-Turnkey) instead.  

## Assumptions

This is an internal Knowledgepath project.  You need to have access to the KP AWS account. If you lack this access, contact your manager.  The project tries to mount an EBS drive with all of the required software installers on it.  This drive exists only in the KP AWS account.  If for some reason it can't be found, the install will fail

## Setup

Step one is to create a file called `env.sh` and put it in the top level directory of this project.  In it you'll put private login and account information that's required to make this project go.

```
export AWS_ACCESS_KEY_ID=<your access key id>
export AWS_SECRET_ACCESS_KEY=<your secret key>
export AWS_PRIVATE_KEY_PATH=</full/path/to/your/key.pem>
export AWS_KEYPAIR_NAME=<your keypair name>
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

`vagrant up --provider aws`

This step can take a long time.  It's setting up an Oracle DB, Endeca and Publishing and Production ATG servers.

## Log in as the vagrant user

If you haven't already, don't forget to source your environment variables:

`. env.sh`

When it finally finishes, you can ssh to the box:

`vagrant ssh`

You'll be logged in to the AWS instance as root.  Change to the vagrant user by typing

`su - vagrant`

## Launch the servers

Launch publishing with:

`/vagrant/scripts/startPublishing.sh`

Then open another terminal window and repeat the "Log in as the vagrant user" step above and then type:

`/vagrant/scripts/startProduction.sh`

If you get a "permission denied" error, the scripts might not be executable:

`sudo chmod 755 /vagrant/scripts/*.sh`

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

Do this from the command line from within the vm.  Ssh to the instance and su to vagrant (see "Log in as the vagrant user") and then type:

`/usr/local/endeca/Apps/CRS/control/promote_content.sh`

## Access the storefront

The CRS application is live at: 

http://192.168.70.5:8080/crs



