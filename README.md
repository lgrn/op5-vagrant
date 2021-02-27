# op5-vagrant

For usage examples, see "Example use" below.

## Unsupported software

While this Vagrant setup makes use of OP5 Monitor, any code in this repository is **strictly unsupported** and comes completely without any type of warranty. For more information, please see [LICENSE](https://github.com/lgrn/op5-vagrant/blob/master/LICENSE).

## Requirements

You need a working Vagrant installation, and a working provider. This configuration assumes Virtualbox or libvirt.

### Using libvirt

NOTE: Ports are identical, so running Virtualbox and libvirt as providers simultaneously will not work with reconfiguration.

Install libvirt stuff. Debian/Ubuntu example:

```
$ sudo apt install qemu qemu-kvm virtinst libvirt-daemon-system libvirt-clients libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base bridge-utils
```

Verify that the service is running:
```
$ sudo systemctl status libvirtd
``` 

Add yourself to `libvirt`, then `su` to avoid having to re-login:

``` 
$ sudo usermod -aG libvirt $(whoami)
$ su - $(whoami)
$ groups
```

## Why

### What is Vagrant?

Vagrant is a tool for building and managing virtual machine environments in a single workflow.

### Is Vagrant Docker?

No, because Docker does not spin up virtual machines. "Vagrant is a tool focused on providing a consistent development environment workflow across multiple operation systems. Docker is a container management that can consistently run software as long as a containerization system exists."

### Some use cases

* You want a clean install of a certain version of OP5 Monitor on a Centos/RHEL 7 system quickly to test something out.
* You want a pre-configured environment with a master and poller (not implemented yet)

## Components

### Vagrantfile

"The primary function of the Vagrantfile is to describe the type of machine required for a project, and how to configure and provision these machines."

For more information, see: https://www.vagrantup.com/docs/vagrantfile/

### provision.sh

This shell-script is loaded when initially deploying a machine. It will install Monitor from the working directory, or from the Internet, and install it.

## Example use

tl;dr Clone this repo and run `vagrant up` for the OP5 installation you want.

You may want to inspect the `Vagrantfile` first and take note of the flags available for `provision.sh`. You can also list them by running the script without any flags:

```
Usage: provision.sh <-r|-p|-v|-t|-m>"
  -r : Run the script."
  -p : Install libraries necessary for PHP debugging."
  -v : Provide verbose output, script is quite silent by default."
  -m : Supply a Monitor version to download, example: '8.2.3'"
```

These flags only affect the Monitor installation. To choose between CentOS/RHEL, different boxes are provided (see below).
### Boxes available
* `vagrant up centos7`, or:
* `vagrant up rhel7`

When selecting `rhel7`, you must provide a RH username and password in `secret.sh`. Rename and fill out `secret.sh_example`.

If you run `vagrant up` without specifying a machine, they will all be deployed.

Ports chosen for forwarding:

* 443 -> 4437 (CentOS 7)
* 443 -> 44377 (RHEL 7)

They differ to ensure the possibility of running both at the same time.

## Customizations

### Vagrantdir

The Vagrantfile is set up to load additional configuration from the directory `Vagrantdir`, if present. Each file in that directory will be loaded as a normal Vagrantfile. This allows you to configure more machines without editing the main Vagrantfile.

### user\_provision.sh

If you want your own provision script, it is suggested that you name it `user_provision.sh`. This is simply because this name is in the `.gitignore` file -- you still have to call the script from the Vagrantfile.
