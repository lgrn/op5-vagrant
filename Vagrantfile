# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: 'virtualbox'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.define "centos7" do |centos7|
    centos7.vm.box = "generic/centos7"
    #to use this, compile namkaran.go for your platform and uncomment
    #centos7.vm.hostname = %x(./namkaran -d EL7).chomp
    centos7.vm.hostname = "localhost"
    centos7.vm.network "forwarded_port", guest: 443, host: 4437
    centos7.vm.network "private_network", type: "dhcp"
    centos7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
  config.vm.define "rhel7" do |rhel7|
    rhel7.vm.box = "generic/rhel7"
    #to use this, compile namkaran.go for your platform and uncomment
    #rhel7.vm.hostname = %x(./namkaran -d RH7).chomp
    rhel7.vm.hostname = "localhost"
    rhel7.vm.network "forwarded_port", guest: 443, host: 44377
    rhel7.vm.network "private_network", type: "dhcp"
    rhel7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
end

# Load user extras
Dir.glob("Vagrantdir/*") do |f|
  load f
end
