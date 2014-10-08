#!/bin/bash
# check for the presence of required software

# be sure to get the sec
if [ -f /vagrant/env.sh ]; then
	. /vagrant/env.sh
else
	echo "ERROR! no env.sh found. Please put your secret keys and passwords in an env.sh file at the top level directory of your project"
	exit 1
fi

echo "Downloading required third-party software installers ..."

declare -a files=(
	"ojdbc7.jar"
	"OCReferenceStore11.1.bin"
	"jboss-eap-6.1.0.zip"
	"jdk-7u67-linux-x64.rpm"
	"OCplatformservices11.1.0-Linux64.bin"
	"OCmdex6.5.1-Linux64_829811.sh"
	"V46389-01.zip"
	"OCcas11.1.0-Linux64.sh"
	"OCPlatform11.1.bin"
	"p13390677_112040_Linux-x86-64_1of7.zip"
	"p13390677_112040_Linux-x86-64_2of7.zip"
)

for file in "${files[@]}"
do
	echo "Checking for the presence of $file in the software directory"
	if [ ! -f /software/$file ]; then
		echo "Downloading third-party software: $file."
		sshpass -p $KP_FTP_PASSWORD sftp -oStrictHostKeyChecking=no $KP_FTP_USERNAME@75.147.51.1:/SSHROOT/client12/software/$file /software/$file
	else
		echo "Required software $file found"
	fi
done

echo "All required third-party software downloaded."