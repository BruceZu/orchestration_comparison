# Cloudify Bluepring

## Introduction

Installs a three-tier based application consisting of NGINX (load-balancer), node.js with Ghost and
PostgreSQL as database on an Openstack Cloud.
This recipe was tested with the 3.2-GA version of Cloudify.

## Usage

* I used a custom Cloudify manager recipe adding support for availability_zones and setting a default DNS-Server for the created Subnet.
This recipe is available [here](https://github.com/dbaur/cloudify-manager-blueprints/tree/3.2-build).
* Replace the values in the inputs.yaml with the correct values for your Openstack setup.

## Limitations

* built only for Ubuntu, relies on apt-get
* the autoscaling policies is not working

