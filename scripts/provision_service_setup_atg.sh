#!/bin/bash

echo "setting up atg services"
cp /vagrant/scripts/atg/atgpublishing /etc/init.d/atgpublishing
chmod 750 /etc/init.d/atgpublishing
chkconfig --add atgpublishing
mkdir -p /home/vagrant/scripts
chown vagrant.vagrant /home/vagrant/scripts
cp /vagrant/scripts/startPublishing.sh /home/vagrant/scripts
cp /vagrant/scripts/stopPublishing.sh /home/vagrant/scripts
chmod u+x /home/vagrant/scripts/startPublishing.sh /home/vagrant/scripts/stopPublishing.sh
chown vagrant.vagrant /home/vagrant/scripts/startPublishing.sh /home/vagrant/scripts/stopPublishing.sh

service atgpublishing stop
service atgpublishing start

cp /vagrant/scripts/atg/atgproduction /etc/init.d/atgproduction
chmod 750 /etc/init.d/atgproduction
chkconfig --add atgproduction
mkdir -p /home/vagrant/scripts
chown vagrant.vagrant /home/vagrant/scripts
cp /vagrant/scripts/startProduction.sh /home/vagrant/scripts
cp /vagrant/scripts/stopProduction.sh /home/vagrant/scripts
chmod u+x /home/vagrant/scripts/startProduction.sh /home/vagrant/scripts/stopProduction.sh
chown vagrant.vagrant /home/vagrant/scripts/startProduction.sh /home/vagrant/scripts/stopProduction.sh

service atgproduction stop
service atgproduction start

echo "atg service setup complete"