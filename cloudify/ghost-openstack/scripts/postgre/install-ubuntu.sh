#!/bin/bash -e

ctx logger info "Installing postgre"
ctx logger debug "${COMMAND}"

sudo apt-get update
sudo apt-get -y install postgresql

sudo echo "host all all 0.0.0.0/0 trust" | sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i "/listen_addresses/c\listen_addresses='*'" /etc/postgresql/9.3/main/postgresql.conf
sudo -H -u postgres bash -c '/usr/bin/createdb ghost_testing -O postgres' 

sudo service postgresql restart

ctx logger info "Installed postgre"