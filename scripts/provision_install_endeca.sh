# endeca

# do this as vagrant
exec sudo -u vagrant /bin/sh - << eof

	# make sure we're in a known good place
	cd /home/vagrant

	# MDEX
	echo "Installing MDEX"
	/software/OCmdex6.5.1-Linux64_829811.sh --silent --target /usr/local > /dev/null 2>&1
	echo "MDEX installation complete"
	source /usr/local/endeca/MDEX/6.5.1/mdex_setup_sh.ini

	# platform services
	echo "installing PlatformServices"
	/software/OCplatformservices11.1.0-Linux64.bin --silent --target /usr/local/ < /vagrant/scripts/endeca_platformservices_silent.silentinput > /dev/null 2>&1
	echo "PlatformServices installation complete"
	source /usr/local/endeca/PlatformServices/workspace/setup/installer_sh.ini

	# tools and frameworks
	export ENDECA_TOOLS_ROOT=/usr/local/endeca/ToolsAndFrameworks/11.1.0
	export ENDECA_TOOLS_CONF=/usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace

	mkdir -p /home/vagrant/installers
	unzip -n /software/V46389-01.zip -d /home/vagrant/installers

	echo "Installing ToolsAndFrameworks"
	/home/vagrant/installers/cd/Disk1/install/silent_install.sh /vagrant/scripts/endeca_toolsandframeworks_silent_response.rsp \
		ToolsAndFrameworks /usr/local/endeca/ToolsAndFrameworks admin
	echo "ToolsAndFrameworks installation complete"

	sudo /opt/oraInventory/orainstRoot.sh

	# CAS
	echo "installing CAS"
	/software/OCcas11.1.0-Linux64.sh --silent --target /usr/local < /vagrant/scripts/endeca_cas_silent.silentinput > /dev/null 2>&1
	echo "CAS installation complete"

	# setup bash profile now that the required files are installed

	echo "source /usr/local/endeca/MDEX/6.5.1/mdex_setup_sh.ini" >> /home/vagrant/.bash_profile \
	 && echo "source /usr/local/endeca/PlatformServices/workspace/setup/installer_sh.ini" >> /home/vagrant/.bash_profile

eof