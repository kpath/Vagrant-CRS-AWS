#!/bin/bash
# check for the presence of required software

# TODO! mount the software EBS at /software
echo "mounting software drive"
if [ ! -e /software ]; then
	mkdir -p /software
	mount -t ext4 /dev/xvdk /software
	chmod -R 755 /software
fi
echo "software drive mounted"

echo "Checking for the presence of required third-party software installers ..."

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
		echo "ERROR! Missing third-party software: $file."
		exit 1
	fi
done

echo "All required third-party software found."