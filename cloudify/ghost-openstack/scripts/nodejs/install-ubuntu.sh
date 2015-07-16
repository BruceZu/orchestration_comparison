#!/bin/bash -e

ctx logger info "Installing nodejs"
ctx logger debug "${COMMAND}"

sudo apt-get update
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

ctx logger info "Installed nodejs"