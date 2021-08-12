# DevSecOps Workshops: Vagrant

This is a brief documentation of Hashicorp Vagrant. For the workshop, visit <a href="https://github.com/mdnfiras/devsecops-vagrant" target="_blank">github.com/mdnfiras/devsecops-vagrant</a>. For a complete documentation, visit <a href="https://www.vagrantup.com/docs/index" target="_blank">vagrantup.com/docs</a>.

## What is Vagrant?

An open source software for building and managing portable virtual environments. It sits on top of a virtualization software (provider) as a wrapper and helps the developer interact easily with it. It automates the configuration of virtual environments using a software configuration management tool (provisioner).

## What are providers?

In Vagrant terminology, a provider is a virtualization software that Vagrant supports, such as VirtualBox, KVM, Hyper-V, Docker containers, VMware, and AWS.
VirtualBox, Hyper-V, and Docker support ships with Vagrant, while VMware, AWS and KVM are supported via plugins.

## What are provisioners?

In Vagrant terminology, a provisioner is a software configuration management tool that Vagrant uses to automate the configuration of virtual environments.
In particular, vagrant supports Chef, Ansible and Puppet, as well as shell provisioning and file transport.

## What is a Vagrant box?

A box (.box format) is a portable environment that can be copied to other machines to replicate the same environment.

## What is a Vagrantfile?

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

## What is the Vagrant CLI?

Vagrant CLI is the command line interface we use to use Vagrant functionalities.

## What is KVM?

Kernel-based Virtual Machine is a virtualization module in the Linux kernel that allows the kernel to function as a hypervisor. KVM requires a processor with hardware virtualization extensions that most of the recent laptop and desktop processors support.

KVM provides device abstraction but no processor emulation. It exposes the /dev/kvm interface, which a user mode host can then use to:

<li>Set up the guest VM's address space. The host must also supply a firmware image (usually a custom BIOS when emulating PCs) that the guest can use to bootstrap into its main OS.</li>
<li>Feed the guest simulated I/O.</li>
<li>Map the guest's video display back onto the system host.</li>

## What is LibVirt?

libvirt is an open-source API, daemon and management tool for managing platform virtualization. It can be used to manage KVM, Xen, VMware ESXi, QEMU and other virtualization technologies. These APIs are widely used in the orchestration layer of hypervisors in the development of a cloud-based solution.
Vagrant uses LibVirt as a plugin to manage KVM.