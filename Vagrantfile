# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  
  config.vm.define "centos6" do |centos6|
    centos6.vm.box = "centos/6"
    centos6.vm.hostname = %x(python3 diablo-name.py EL6).chomp
    centos6.vm.network "forwarded_port", guest: 443, host: 4436
    centos6.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "centos/7"
    centos7.vm.hostname = %x(python3 diablo-name.py EL7).chomp
    centos7.vm.network "forwarded_port", guest: 443, host: 4437
    centos7.vm.provision "shell", path: "provision.sh"
  end
  
  config.vm.define "nc" do |nc|
    nc.vm.box = "centos/7"
    nc.vm.hostname = %x(python3 diablo-name.py naemon).chomp
    nc.vm.network "forwarded_port", guest: 443, host: 4439
  end  
  
  config.vm.define "beta8" do |beta8|
    beta8.vm.box = "centos/7"
    beta8.vm.hostname = %x(python3 diablo-name.py beta).chomp
    beta8.vm.network "forwarded_port", guest: 443, host: 4440
    beta8.vm.provision "shell", path: "betaprov.sh"
  end

end
