# -*- mode: ruby -*-
# vi: set ft=ruby :

box = "ubuntu/focal64"

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-vbguest", "vagrant-hostmanager"]
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true

  config.vm.box = box

  # master node
  config.vm.define "master" do |m|
    m.vm.hostname = "master.k8s"
    m.vm.network "private_network", ip: "192.168.200.10"
    m.vm.provider "virtualbox" do |vbox|
      vbox.gui = false
      vbox.cpus = 2
      vbox.memory = 2048
    end

    m.vm.provision :shell, :path => "scripts/setup-common.sh"
    m.vm.provision :shell, :path => "scripts/setup-master.sh"
  end

  # worker node
  (1..2).each do |i|
    config.vm.define "worker-#{i}" do |w|
      w.vm.hostname = "worker-#{i}.k8s"
      w.vm.network "private_network", ip: "192.168.200.#{10+i}"
      w.vm.provider "virtualbox" do |vbox|
        vbox.gui = false
        vbox.cpus = 1
        vbox.memory = 1024
      end

      w.vm.provision :shell, :path => "scripts/setup-common.sh"
      w.vm.provision :shell, :path => "scripts/setup-worker.sh"
    end
  end

end
