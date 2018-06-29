# op5-vagrant

## Unsupported software

While this Vagrant setup makes use of OP5 Monitor, any code in this repository is **strictly unsupported** and comes completely without any type of warranty. For more information, please see [LICENSE](https://github.com/lgrn/op5-vagrant/blob/master/LICENSE).

## Example use

Clone this repo and run `vagrant up` for the OP5 installation you want:

* `vagrant up centos6`
* `vagrant up centos7`

If you run `vagrant up` without specifying a machine, they will all be deployed.

Port forwarding is tied to CentOS version:

* 443 -> 4436 (CentOS 6)
* 443 -> 4437 (CentOS 7)
