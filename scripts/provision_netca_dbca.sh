#!/bin/bash

exec sudo -u oracle /bin/bash -l << eof

	netca -silent -responseFile /opt/oracle/product/11.2.0/dbhome_1/assistants/netca/netca.rsp

	dbca -silent -createDatabase -responseFile /vagrant/scripts/dbca.rsp

eof