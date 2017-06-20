# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if ENV['VAGRANT_DEFAULT_PROVIDER'] == "libvirt"
    config.vm.box = "ubnt/xenial64-libvirt"
  else
    config.vm.box = "ubuntu/xenial64"
  end

  config.vm.provision :saltdeps do |deps|
    deps.base_vagrantfile = "git@github.com:Ubiquiti-Cloud/salt-vagrant-base.git"
    deps.checkout_path =  "./.vagrant-salt/deps"
  end
end
