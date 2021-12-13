#!/bin/bash

sudo ovs-docker del-port ovs-br0 eth1 ovs-container
sudo ovs-docker add-port ovs-br0 eth1 ovs-container --ipaddress=10.0.0.4/24
