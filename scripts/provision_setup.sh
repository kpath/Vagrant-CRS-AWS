#!/bin/bash
# this script runs once on provision
# at the end of it, you've got a database ready for connections from ATG

# it's okay to run this twice
echo "making sure root volue is the right size"
resize2fs /dev/xvde1
echo "resizing done"

# TODO! mount the software EBS at /software
echo "mounting software drive"
if [ ! -f /software ]; then
	mkdir -p /software
	mount -t ext4 /dev/xvdk /software
	chmod -R 755 /software
fi
echo "software drive mounted"

# swap space
echo "createing swap space"
if [ ! -e /var/swap.1 ]; then
	/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
	/sbin/mkswap /var/swap.1
	/sbin/swapon /var/swap.1
fi
echo "swap space created"

if  ! grep -qe "^/var/swap.1" "/etc/fstab"; then
	echo "/var/swap.1 swap swap defaults 0 0" >> /etc/fstab
else
	echo "Swap space in /etc/fstab already set up"
fi

# verify centos release
cat /etc/centos-release

# fastestmirror plugin causes problems. just disable plugins
sed -i.bak 's/plugins=1/plugins=0/g' /etc/yum.conf

if  ! grep -qe "^assumeyes" "/etc/yum.conf"; then
	echo "assumeyes=1" >> /etc/yum.conf
else
	sed -i.bak 's/assumeyes=0/assumeyes=1/g' /etc/yum.conf
fi

# convert into Oracle Linux 6, if we haven't already
if [ ! -f /etc/oracle-release ]; then
	curl -O https://linux.oracle.com/switch/centos2ol.sh
	sh centos2ol.sh; echo success
fi

# verify oracle release
cat /etc/oracle-release

# upgrade yum
yum upgrade -y

# install some tools and libraries that are required
yum install -y unzip libaio telnet sshpass

# install the 11g prereqs
yum install -y oracle-rdbms-server-11gR2-preinstall

# create directories
mkdir -p /opt/oracle /opt/oraInventory /opt/datafile \
 && chown oracle:oinstall -R /opt

# set Oracle environment variables

if  ! grep -qe "^export ORACLE_BASE=" "/home/oracle/.bash_profile"; then
	echo "export ORACLE_BASE=/opt/oracle" >> /home/oracle/.bash_profile \
 		&& echo "export ORACLE_HOME=/opt/oracle/product/11.2.0/dbhome_1" >> /home/oracle/.bash_profile \
 		&& echo "export ORACLE_SID=orcl" >> /home/oracle/.bash_profile \
 		&& echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bash_profile
fi

# ======================================

# add the vagrant user and add them to sudoers

if [ ! -d /home/vagrant ]; then
	useradd --create-home -s /bin/bash -G oinstall vagrant
fi

if [ ! -f /etc/sudoers.d/vagrant ]; then
	echo 'vagrant ALL=NOPASSWD:ALL' > /tmp/vagrant
	chmod 0440 /tmp/vagrant
	mv /tmp/vagrant /etc/sudoers.d/
else
	echo "vagrant already set up in sudoers"
fi

# set ATG environment variables
if  ! grep -qe "^export ENDECA_TOOLS_CONF=" "/home/vagrant/.bash_profile"; then
	echo "export JAVA_HOME=/usr/java/jdk1.7.0_67" >> /home/vagrant/.bash_profile \
	 && echo "export DYNAMO_HOME=/home/vagrant/ATG/ATG11.1/home" >> /home/vagrant/.bash_profile \
	 && echo "export JBOSS_HOME=/home/vagrant/jboss" >> /home/vagrant/.bash_profile \
	 && echo "export ATG_HOME=/home/vagrant/ATG/ATG11.1/home" >> /home/vagrant/.bash_profile \
	 && echo "export ATG_DIR=/root/ATG/ATG11.1" >> /home/vagrant/.bash_profile \
	 && echo "export JAVA_VM=/usr/java/jdk1.7.0_67/bin/java" >> /home/vagrant/.bash_profile \
	 && echo "export JAVA_ARGS=-Duser.timezone=UTC" >> /home/vagrant/.bash_profile \
	 && echo "export JAVA_OPTS=-Duser.timezone=UTC" >> /home/vagrant/.bash_profile \
	 && echo "export ENDECA_TOOLS_ROOT=/usr/local/endeca/ToolsAndFrameworks/11.1.0" >> /home/vagrant/.bash_profile \
	 && echo "export ENDECA_TOOLS_CONF=/usr/local/endeca/ToolsAndFrameworks/11.1.0/server/workspace" >> /home/vagrant/.bash_profile \
	 && echo "export PATH=/usr/java/jdk1.7.0_67/bin:$PATH" >> /home/vagrant/.bash_profile
fi

# jdk
rpm -Uvh /vagrant/software/jdk-7u67-linux-x64.rpm

# directories
if [ ! -d /usr/local/endeca/Apps ]; then
	mkdir -p /usr/local/endeca/Apps
	chmod -R 755 /usr/local/endeca
	chown -R vagrant:vagrant /usr/local/endeca
fi

