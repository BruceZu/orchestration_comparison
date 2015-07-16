#!/bin/bash -e

ctx logger info "Starting ghost"
ctx logger debug "${COMMAND}"

cwd=$(pwd)
cd /opt/ghost
sudo /usr/bin/npm install
sudo nohup /usr/bin/npm start > /dev/null 2>&1 &
cd $cwd

ctx logger info "Started ghost"