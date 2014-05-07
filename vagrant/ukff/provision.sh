#!/bin/bash


# Uncomment the line below to run without a salt master
# You'll need to put pillar data in ../../../pillar
#
cp /vagrant/minion.config.local /etc/salt/minion

# Uncomment these lines if you are running with a master

# NOW=$(date +"%Y-%m-%d-%H-%M")
# sed -i "s/#id:/id: ukff_vagrant_$NOW/g" /etc/salt/minion
# sed -i 's/#master: salt/master: saltmaster.example.com/g' /etc/salt/minion

service salt-minion restart
