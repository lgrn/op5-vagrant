# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  
  config.vm.define "centos6" do |centos6|
    centos6.vm.box = "centos/6"
    centos6.vm.hostname = %x(python diablo-name.py EL6).chomp
    centos6.vm.network "forwarded_port", guest: 443, host: 4436
    centos6.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "centos/7"
    centos7.vm.hostname = %x(python diablo-name.py EL7).chomp
    centos7.vm.network "forwarded_port", guest: 443, host: 4437
    centos7.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "ncore" do |ncore|
    ncore.vm.box = "centos/7"
    ncore.vm.hostname = %x(python diablo-name.py core).chomp
    ncore.vm.network "forwarded_port", guest: 443, host: 4430
    ncore.vm.provision "shell", path: "core_provision.sh"
  end

end
