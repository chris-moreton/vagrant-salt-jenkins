# Vagrant/Salt/Jenkins/Dashing

This repo holds the Salt state definitions that can be used by a Salt master to be used in a deployment pipeline as described in my [blog post on the subject](http://www.afewmorelines.com/a-full-deployment-pipeline-using-vagrant-saltstack-and-jenkins/).

Perhaps the most useful thing here is the definition of the Jenkins box which installs the Jenkins server along with some job definitions, remote-access keys and the Dashing dashboard service.

It contains Vagrant configs for firing up any box in the process as a local VM. Vagrant is not currently used to provision the boxes in the cloud - to do that we create the cloud machine then configure it to use the Salt master and bring up the highstate.

I don't use the Salt provisioner in Vagrant, instead I have created a [VMware box with Salt 2014.1.3 installed](https://vagrantcloud.com/netsensia/ubuntu-trusty64-salt) which saves some time when Vagrant would otherwise be bootstrapping a clean VM with Salt.

You'll notice Salt states that are not used. These are states that I have used for various projects which I've removed from this public repo as they describe machine configs for clients and are not appropriate for being made public. The states themselves are generic so I've left them in for reference and for future use.

## Building Jenkins

### In a local VM

Copy the pillar directory to the same level as this repo, e.g.

	cp -R pillar ../
	
Then, add the pillar data, then:

	cd vagrant-salt-jenkins/vagrant/jenkins
	vagrant up --provider vmware_fusion (or vmware_workstation)
	vagrant ssh
	sudo bash
	salt-call state.highstate
	
Within the vagrant directory, you can create additional Vagrant setups for other machines in your deployment pipeline. Do this by copying the Jenkins config and making the following change:

In minion.config.local, change

	id: jenkins_vagrant
	
to

	id: newproject_vagrant
	
The id is important for allowing Salt to determine which Salt states to use. For example, for 'jenkins_vagrant', Salt will apply the states it has listed under its 'jenkins*' section. As the name also contains 'vagrant', it can also use this information if necessary, although there are other ways for Salt to determine if you are building a local VM. 

Note: If using a Salt master, the line to change is:

    sed -i "s/#id:/id: jenkins_vagrant_$NOW/g" /etc/salt/minion

## Using a Salt master

A Salt master can be used to configure your local VMs, although this is probably unneccesary in most circumstances. However, if you are provisioning a machine outside of your local environment wuthout using Vagrant you may find it easier to use a Salt master. If managing multiple machines with varying setups, using a Salt master also has the rather large benefit of allowing you to control all your minions from a single box. If, for example, you want to make an upgrade across all your machines, you can define the upgrade once in your Salt master's state repository, and then ask all your minions to bring themselves in line with the current 'highstate' config.

The provision.sh script contains information on what to do to set up your Vagrant VMs to use a Salt master.

Before you can do it is necessary that Salt master be configure. Do this by this repo to the box which will be your Salt master and then populate the pillar data. Each time a machine is created that needs to use the Salt master, you will need to authenticate it my accepting its key on the Salt master using the 'salt-key' command.

