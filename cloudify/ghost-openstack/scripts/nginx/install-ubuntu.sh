#!/bin/bash -e

ctx logger info "Installing nginx"
ctx logger debug "${COMMAND}"

sudo apt-get update
sudo apt-get -y install nginx

ctx logger info "Installed nginx"