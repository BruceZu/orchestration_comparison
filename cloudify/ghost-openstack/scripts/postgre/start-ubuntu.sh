#!/bin/bash -e

ctx logger info "Starting postgre"
ctx logger debug "${COMMAND}"

sudo service postgresql start

ctx logger info "Started postgre"