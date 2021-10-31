# DevSecOps Workshops: Vagrant

This is a brief documentation of Hashicorp Vagrant, followed by a workshop. For the workshop material, visit <a href="https://github.com/mdnfiras/devsecops-vagrant" target="_blank">github.com/mdnfiras/devsecops-vagrant</a>. For a complete documentation, visit <a href="https://www.vagrantup.com/docs/index" target="_blank">vagrantup.com/docs</a>.

## What is Vagrant?

An open source software for building and managing portable virtual environments. It sits on top of a virtualization software (provider) as a wrapper and helps the developer interact easily with it. It automates the configuration of virtual environments using a software configuration management tool (provisioner).

### What are providers?

In Vagrant terminology, a provider is a virtualization software that Vagrant supports, such as VirtualBox, KVM, Hyper-V, Docker containers, VMware, and AWS.
VirtualBox, Hyper-V, and Docker support ships with Vagrant, while VMware, AWS and KVM are supported via plugins.

KVM is a very interesting technology that is worth researching. However, we will be using VirtualBox as our virtualization provider.

### What are provisioners?

In Vagrant terminology, a provisioner is a software configuration management tool that Vagrant uses to automate the configuration of virtual environments.
In particular, vagrant supports Chef, Ansible and Puppet, as well as shell provisioning and file transport.

### What is a Vagrant box?

A box (.box format) is a portable environment that can be copied to other machines to replicate the same environment.

### What is a Vagrantfile?

A Vagrantfile (also named Vagrantfile on the FS) contains the description of the virtual machines. Vagrant runs a Vagrantfile per project, which makes uploading it to source control along the developer’s code a good practice.

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby:

provision1 = "initscript/provision1.sh"
provision2 = "initscript/provision2.sh"

nodes = [
    {:hostname => "node1", :ip => "192.168.5.11", :cpus => 2, :mem => 2048, :script => provision1},

    {:hostname => "node2", :ip => "192.168.5.12", :cpus => 2, :mem => 2048, :script => provision1},

    {:hostname => "node3", :ip => "192.168.5.10", :cpus => 2, :mem => 2048, :script => provision2}
]


Vagrant.configure(2) do |config|
	nodes.each do |node|
		config.vm.define node[:hostname] do |wmachine|
			# Download box in insecure mode (no certificate is required)
			config.vm.box_download_insecure = true
			# Used box, will be downloaded from Vagrant Cloud
			config.vm.box = "peru/ubuntu-18.04-server-amd64"
			# Turn off updates
			config.vm.box_check_update = false
			# VM hostname
			wmachine.vm.hostname = node[:hostname]
			# Connect to an internal private network with the specified IP
			wmachine.vm.network :private_network, :ip => node[:ip]
			# Connect to the public network via a bridged interface
			config.vm.network :public_network,
				       # “virbr2” is the host interface that is connected to the public network
               			       :dev => "virbr2",
               			       :mode => "bridge",
              		 	       	       :type => "bridge"
			# Specify the provider (libvirt, virtualbox, ...), and the RAM memory and number of virtual CPUs
			wmachine.vm.provider :libvirt do |domain|
				domain.memory = node[:mem]
				domain.cpus = node[:cpus]
			end
			# Specify the provisioning script to run after booting up the machine
			wmachine.vm.provision :shell, path: node[:script]
		end
	end
end
```

### What is the Vagrant CLI?

Vagrant CLI is the command line interface we use to use Vagrant functionalities.

## Start using Vagrant

### Check hardware virtualization support in your system

On linux, run the following command to check if your CPU supports hardware virtuaization:

```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo
```

If the output is anything different than 0, then your CPU supports hardware virtualization. Else, you may have to restart your computer, enter your bios settings, and enable hardware virtualization.

### Install VirtualBox

We will be using VirtualBox as our virtualization technology and provider. Check installation instructutions here: <a href="https://www.virtualbox.org/wiki/Downloads">virtualbox.org/wiki/Downloads</a>.

### Install Vagrant

Check installation instructutions here: <a href="https://www.vagrantup.com/docs/installation">vagrantup.com/docs/installation</a>.

### Launching Vagrant machines

Navigate to the workshop folder (where the file `Vagrantfile` resides) and run:

```bash
vagrant up
```

That command should start the virtual machine we described in the `Vagrantfile`. Physically, the virtual machine files will be stored in that same directiry under a hidden folder named `.vagrant`, do not mess with that folder. Managing this new VM and accessing it through the vagrant CLI is only possible from within the current folder (where the `Vagrantfile` resides).

The shell provisioner will install `Nginx` web server as instructed in the `init.sh` script, and then port `8080` of the host will be forwarded to port `80` of the virtual machine, so you can visit <a href="http://localhost:8080" target="_blank">`http://localhost:8080`</a> to see the `index.html` that we've also trasported inside the VM using the file provisioner.

Run the following command to ssh into the virtual machine:

```bash
vagrant ssh
```

If multiple VMs have been defined in the Vagrantfile, then the last command (and many others) must be followed by the hostname of the VM used in the Vagrantfile:

```bash
vagrant ssh web-server
```

For more information about the Vagrant CLI, run:

```bash
vagratn --help
```

