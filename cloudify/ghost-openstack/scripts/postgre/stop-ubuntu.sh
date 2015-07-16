#!/bin/bash -e

ctx logger info "Stopping postgre"
ctx logger debug "${COMMAND}"

sudo service postgresql stop

ctx logger info "Stoped postgre"