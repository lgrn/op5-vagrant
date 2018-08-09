# op5-vagrant

## Unsupported software

While this Vagrant setup makes use of OP5 Monitor, any code in this repository is **strictly unsupported** and comes completely without any type of warranty. For more information, please see [LICENSE](https://github.com/lgrn/op5-vagrant/blob/master/LICENSE).

## Requirements

You need a working Vagrant installation, and a working provider. This configuration assumes Virtualbox.

## Why

### What is Vagrant?

Vagrant is a tool for building and managing virtual machine environments in a single workflow.

### Is Vagrant Docker?

No, because Docker does not spin up virtual machines. "Vagrant is a tool focused on providing a consistent development environment workflow across multiple operation systems. Docker is a container management that can consistently run software as long as a containerization system exists."

### Some use cases

* You want a clean install of a certain version of OP5 Monitor on a Centos 6/7 (or both) system/s quickly to test something out.
* You want a pre-configured environment with a master and poller (not implemented yet)

## Components

### Vagrantfile

"The primary function of the Vagrantfile is to describe the type of machine required for a project, and how to configure and provision these machines."

For more information, see: https://www.vagrantup.com/docs/vagrantfile/

### provision.sh

This shell-script is loaded when initially deploying a machine. It will install grab Monitor from the working directory, or from the Internet, and install it.

## Example use

Clone this repo and run `vagrant up` for the OP5 installation you want:

* `vagrant up centos6`
* `vagrant up centos7`

If you run `vagrant up` without specifying a machine, they will all be deployed.

Ports chosen for forwarding are related to the CentOS version to make them easier to remember:

* 443 -> 4436 (CentOS 6)
* 443 -> 4437 (CentOS 7)
