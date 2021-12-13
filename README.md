# ⛔ DEPRECATED

# op5-vagrant

For usage examples, see "Example use" below.

## Unsupported software

While this Vagrant setup makes use of OP5 Monitor, any code in this repository is **strictly unsupported** and comes completely without any type of warranty. For more information, please see [LICENSE](https://github.com/lgrn/op5-vagrant/blob/master/LICENSE).

## Requirements

You need a working Vagrant installation, and a working provider. This configuration assumes Virtualbox or libvirt.

### Using libvirt

NOTE: Ports are identical, so running Virtualbox and libvirt as providers simultaneously will not work without reconfiguration.

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

When `libvirt` is available, you need the following two vagrant plugins:

``` 
$ vagrant plugin install vagrant-libvirt
$ vagrant plugin install vagrant-mutate
```

If you're on a really cool Linux distribution where packages are too new and dependency resolutions bugs out, installing these plugins may require you to set `VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1`.

## Why

### What is Vagrant?

Vagrant is a tool for building and managing virtual machine environments in a single workflow.

## Components

### Vagrantfile

"The primary function of the Vagrantfile is to describe the type of machine required for a project, and how to configure and provision these machines."

This is where you define your machines, forward ports, set hostnames and more.

For more information, see: https://www.vagrantup.com/docs/vagrantfile/

### provision.sh

This shell-script is loaded when initially deploying a machine. Run it without any flags for usage information. Note that the flags probably need to be in the correct order.

## Example use

tl;dr Clone this repo and run `vagrant up` for the OP5 installation you want. You need a working provider, like Virtualbox or libvirt on Linux.

You may want to inspect the `Vagrantfile` first and take note of the flags available for `provision.sh`. You can also list them by running the script without any flags.

These flags only affect the Monitor installation process, for example if you want PHP debugging tools installed. To choose between CentOS/RHEL, different boxes are provided.

### Boxes available

#### Virtualbox (v)
* `vagrant up vc7`, or:
* `vagrant up vr7`

#### libvirt (l)
* `vagrant up lc7`, or:
* `vagrant up lr7`

When selecting RHEL (r), you must provide a RH username and password in `secret.sh`. The system will then be registered for you automatically. Rename and fill out `secret.sh_example`.

If you run `vagrant up` without specifying a machine, they will all be deployed. That's not a good idea, since they conflict.

Note that you should always check your `Vagrantfile` for values like ports as this documentation may be out of date.

### Create your own box

If you want to re-use a box after the initial installation to speed things up, you first need to re-add the insecure Vagrant key. From inside the VM, run:

```
$ echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> /home/vagrant/.ssh/authorized_keys
```

For some reason, with libvirt the kernel needs to be readable before creating a box:

```
sudo chmod +r /boot/vmlinuz-*
```

You can now create your own box. Example:

```
$ vagrant package lc7                     # created as package.box
$ vagrant box add package.box --name op5  # import package.box as "op5"

expect:
==> box: Successfully added box 'op5' (v0) for 'libvirt'!

$ vagrant box list
(...)
op5      (libvirt, 0)

$ rm package.box
```
The imported box ("op5") is stored in `~/.vagrant.d/boxes/`. Presumably you can use `--force` with `box add` to replace (update) your local box.

Now set up a new VM in your `Vagrantfile` like `lc72.vm.box = "op5"`. No other attributes are necessary but you probably wants hostnames:

```
config.vm.define "lc72" do |lc72|
  lc72.vm.hostname = "lc72"
  lc72.vm.box = "op5"
end
config.vm.define "lc73" do |lc73|
  lc73.vm.hostname = "lc73"
  lc73.vm.box = "op5"
end

# etc...
```

In practice this allows you to just run the provisioning once, and then deploy N amount of identical VMs. Vagrant will make sure they have different IP addresses, and communication in between them should work without any additional configuration.

## Customizations

### Vagrantdir

The Vagrantfile is set up to load additional configuration from the directory `Vagrantdir`, if present. Each file in that directory will be loaded as a normal Vagrantfile. This allows you to configure more machines without editing the main Vagrantfile, and it also ensures it's not overwritten by this repo.

### user\_provision.sh

If you want your own provision script, it is suggested that you name it `user_provision.sh`. This is simply because this name is in the `.gitignore` file -- you still have to call the script from the Vagrantfile.
