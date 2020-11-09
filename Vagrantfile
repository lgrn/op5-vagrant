# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "centos/7"
    centos7.vm.hostname = %x(./namkaran -d EL7).chomp
    centos7.vm.network "forwarded_port", guest: 443, host: 4437
    centos7.vm.network "private_network", type: "dhcp"
    centos7.vm.provision "shell", path: "provision.sh", :args => "-r -v -p -m 8.2.3"
  end
end

# Load user extras
Dir.glob("Vagrantdir/*") do |f|
  load f
end
