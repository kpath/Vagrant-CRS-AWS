# ATG CRS on AWS Guide

### About

This project gives you a quick and easy way to stand up an ATG CRS 11.1 server on Amazon AWS.  This is good for demos and just for playing around with a running instance.  If you have a laptop that can run the ATG CRS locally, you can use the [Turnkey project](https://github.com/grahammather/ATG-CRS-Turnkey) instead.  

### Assumptions

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

## Go!

Open a shell and navigate to the top level directory of this project and type

`$ vagrant up --provider aws`


