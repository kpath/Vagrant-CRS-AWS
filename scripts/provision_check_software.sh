#!/bin/bash
# check for the presence of required software

echo "Checking for the presence of required third-party software installers ..."

declare -a files=(
"p13390677_112040_Linux-x86-64_1of7.zip"
"p13390677_112040_Linux-x86-64_2of7.zip"
#"jboss-eap-6.1.0.zip"
#"jdk-7u67-linux-x64.rpm"
#"OCPlatform11.1.bin"
#"ojdbc7.jar"
#"OCcas11.1.0-Linux64.sh"
#"OCmdex6.5.1-Linux64_829811.sh"
#"OCplatformservices11.1.0-Linux64.bin"
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