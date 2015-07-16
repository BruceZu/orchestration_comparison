#!/bin/bash

set -e

ctx source instance runtime_properties postgre_ip_address $(ctx target instance host_ip)