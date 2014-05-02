# Vagrant/Salt/Jenkins

Various Salt state definitions and an example Vagrant config for setting up a local Jenkins VM.

I don't use the Salt provisioner in Vagrant, instead I have created a [VMware box with Salt 2014.1.3 installed](https://vagrantcloud.com/netsensia/ubuntu-trusty64-salt) which saves some time when Vagrant would otherwise be bootstrapping a clean VM with Salt.

I then SSH into the VM and call the highstate manually:

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

The provision.sh script contains information on what to do to set up your Vagrant VMs to use a Salt master.

Before you can do it is necessary that Salt master be configure. Do this by this repo to the box which will be your Salt master and then populate the pillar data. Each time a machine is created that needs to use the Salt master, you will need to authenticate it my accepting its key on the Salt master using the 'salt-key' command.

