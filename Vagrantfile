# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  
  config.vm.define "centos6" do |centos6|
    centos6.vm.box = "centos/6"
    centos6.vm.hostname = %x(python diablo-name.py CO6).chomp
    centos6.vm.network "forwarded_port", guest: 443, host: 4436
    centos6.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "centos/7"
    centos7.vm.hostname = %x(python diablo-name.py CO7).chomp
    centos7.vm.network "forwarded_port", guest: 443, host: 4437
    centos7.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "rhel6" do |rhel6|
    rhel6.vm.box = "samdoran/rhel6"
    rhel6.vm.hostname = %x(python diablo-name.py RH6).chomp
    rhel6.vm.network "forwarded_port", guest: 443, host: 4446
#    rhel6.vm.provision "shell", path: "provision.sh"
  end

  config.vm.define "rhel7" do |rhel7|
    rhel7.vm.box = "samdoran/rhel7"
    rhel7.vm.hostname = %x(python diablo-name.py RH7).chomp
    rhel7.vm.network "forwarded_port", guest: 443, host: 4447
#    rhel7.vm.provision "shell", path: "provision.sh"
  end
end
