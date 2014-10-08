#!/bin/bash

# run this part as oracle
exec sudo -u oracle /bin/sh - << eof

	mkdir -p /home/oracle/installers

	unzip -n /software/p13390677_112040_Linux-x86-64_1of7.zip -d /home/oracle/installers
	unzip -n /software/p13390677_112040_Linux-x86-64_2of7.zip -d /home/oracle/installers

	/home/oracle/installers/database/runInstaller -waitforcompletion -silent -ignorePrereq -responseFile /vagrant/scripts/db_install.rsp 
eof