# DevSecOps Workshops: Vagrant

This is a brief documentation of Hashicorp Vagrant, followed by a workshop. For the workshop material, visit <a href="https://github.com/mdnfiras/devsecops-vagrant" target="_blank">github.com/mdnfiras/devsecops-vagrant</a>. For a complete documentation, visit <a href="https://www.vagrantup.com/docs/index" target="_blank">vagrantup.com/docs</a>.

## What is Vagrant?

An open source software for building and managing portable virtual environments. It sits on top of a virtualization software (provider) as a wrapper and helps the developer interact easily with it. It automates the configuration of virtual environments using a software configuration management tool (provisioner).

### What are providers?

In Vagrant terminology, a provider is a virtualization software that Vagrant supports, such as VirtualBox, KVM, Hyper-V, Docker containers, VMware, and AWS.
VirtualBox, Hyper-V, and Docker support ships with Vagrant, while VMware, AWS and KVM are supported via plugins.

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

### What is KVM?

Kernel-based Virtual Machine is a virtualization module in the Linux kernel that allows the kernel to function as a hypervisor. KVM requires a processor with hardware virtualization extensions that most of the recent laptop and desktop processors support.

KVM provides device abstraction but no processor emulation. It exposes the /dev/kvm interface, which a user mode host can then use to:

<li>Set up the guest VM's address space. The host must also supply a firmware image (usually a custom BIOS when emulating PCs) that the guest can use to bootstrap into its main OS.</li>
<li>Feed the guest simulated I/O.</li>
<li>Map the guest's video display back onto the system host.</li>

### What is LibVirt?

libvirt is an open-source API, daemon and management tool for managing platform virtualization. It can be used to manage KVM, Xen, VMware ESXi, QEMU and other virtualization technologies. These APIs are widely used in the orchestration layer of hypervisors in the development of a cloud-based solution.
Vagrant uses LibVirt as a plugin to manage KVM.

## Start using Vagrant

### Check hardware virtualization support in your system

Run the following command to check if your CPU supports hardware virtuaization:

```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo
```

If the output is anything different than 0, then your CPU supports hardware virtualization.

### Installing KVM and libvirt

Run the following commands to install KVM:

```bash
sudo apt update
sudo apt install cpu-checker
```

Once installed, check if your system can run hardware-accelerated KVM virtual machines:

```bash
kvm-ok
```

Output should be something like this:

```
INFO: /dev/kvm exists
KVM acceleration can be used
```

Run the following command to additional virtualization management packages:

```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
```

`qemu-kvm` is a software that provides hardware emulation for the KVM hypervisor.

`libvirt-daemon-system` are configuration files to run the libvirt daemon as a system service.

`libvirt-clients` is a software for managing virtualization platforms.

`bridge-utils` is a set of command-line tools for configuring ethernet bridges.

`virtinst` is a set of command-line tools for creating virtual machines.

`virt-manager` is an easy-to-use GUI interface and supporting command-line utilities for managing virtual machines through libvirt.

Once the packages are installed, the libvirt daemon will start automatically. You can verify it by typing:

```bash
sudo systemctl is-active libvirtd
```

Output:
```
active
```

Additional information about setting up KVM and libvirt can be found here: https://linuxize.com/post/how-to-install-kvm-on-ubuntu-20-04/.

If for some reason KVM or libvirt is not working, you can continue by installing Virtualbox and using it as the Vagrant provider for all workshops.

### Launching Vagrant machines

Navigate to the workshop folder (where the file Vagrantfile resides) and run:

```bash
vagrant up
```

That command should start the virtual machine we described in the Vagrantfile. This virtual machine will reside in that same folder, meaning managing it and accessing it through the vagrant CLI is only possible from within the current folder.

The shell provisioner will install `Nginx` web server as instructed in the `init.sh` script, and then port `8080` of the host will be forwarded to port `80` of the virtual machine, so you can visit <a href="http://localhost" target="_blank">`http://localhost`</a> to see the `index.html` that we've also trasported inside the VM using the file provisioner.

By running the following command, you can see the `.vagrant` hidden file that contains the virtual machine files:

```bash
ls -a
```

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

