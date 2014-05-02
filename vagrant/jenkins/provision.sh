#!/bin/bash

# Uncomment the line below to run without a salt master
# You'll need to put pillar data in ../../../pillar
#
cp /vagrant/minion.config.local /etc/salt/minion

# Use this line if you are running with a master and change saltmaster.example.com to point to your Salt master box
# sed -i 's/#master: salt/master: saltmaster.example.com/g' /etc/salt/minion

# Uncomment these three lines if running with a Salt master
# NOW=$(date +"%Y-%m-%d-%H-%M")
# sed -i "s/#id:/id: jenkins_vagrant_$NOW/g" /etc/salt/minion
# service salt-minion restart
