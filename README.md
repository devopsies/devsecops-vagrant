# DevSecOps Workshop : Vagrant

For documentation about the tools used in this workshop, check the `docs/` folder.

## Check hardware virtualization support in your system

Run the following command to check if your CPU supports hardware virtuaization:

```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo
```

If the output is anything different than 0, then your CPU supports hardware virtualization.

## Installing KVM and libvirt

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

## Launching Vagrant machines

Navigate to the workshop folder (where the file Vagrantfile resides) and run:

```bash
vagrant up
```

That command should start the virtual machine we described in the Vagrantfile. This virtual machine will reside in that same folder, meaning managing it and accessing it through the vagrant CLI is only possible from within the current folder.

The shell provisioner will install `Nginx` web server as instructed in the `init.sh` script, and then port `8080` of the host will be forwarded to port `80` of the virtual machine, so you can visit `http://localhost` to see the `index.html` that we've also trasported inside the VM using the file provisioner.

By running the following command, you can see the `.vagrant` hidden file that contains the virtual machine files:

```bash
ls -a
```

Run the following command to ssh into the virtual machine:

```bash
vagrant ssh
```

If multiple VMs have been defined in the Vagrantfile, then the last command (and many others) must be followed by the hostname of the VM:

```bash
vagrant ssh web
```

For more information about the Vagrant CLI, run:

```bash
vagratn --help
```

