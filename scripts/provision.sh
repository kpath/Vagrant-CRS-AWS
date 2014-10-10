#!/bin/bash
# Provision the instance

chmod 750 /vagrant/scripts/*.sh

ALL_PROVISIONERS="software setup db-install db-postinstall netcadbca db-import db-service install-endeca endeca-service install-atg install-crs-artifacts atg-service"

if [[ $@ ]]; then
    PROVISIONERS=$@
else
    PROVISIONERS=$ALL_PROVISIONERS
fi

for p in $PROVISIONERS
do
    case "$p" in
        software)
            /vagrant/scripts/provision_check_software.sh
            ;;     
        setup)
            /vagrant/scripts/provision_setup.sh
            ;;
        db-install)
            /vagrant/scripts/provision_install_db.sh
            ;;
        db-postinstall)
            /vagrant/scripts/provision_postinstall_db.sh
            ;;
        netcadbca)
            /vagrant/scripts/provision_netca_dbca.sh
            ;;
        db-import)
            /vagrant/scripts/provision_import.sh
            ;;
        db-service)
            /vagrant/scripts/provision_service_setup_db.sh
            ;;
        install-endeca)
            /vagrant/scripts/provision_install_endeca.sh
            ;;
        endeca-service)
            /vagrant/scripts/provision_service_setup_endeca.sh
            ;;
        install-atg)
            /vagrant/scripts/provision_install_atg.sh
            ;;
        install-crs-artifacts)
            /vagrant/scripts/provision_install_crs_artifacts.sh
            ;;
        atg-service)
            /vagrant/scripts/provision_service_setup_atg.sh
            ;;
        sync)
            echo "/vagrant directory has been synced"
            ;;
        *)
            echo "Invalid provisioning arg $p.  Valid args are: $ALL_PROVISIONERS"
            ;;
    esac
done

