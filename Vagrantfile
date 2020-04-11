# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.hostname = 'nusskylab'

  # Forward the Rails server default port to the host
  config.vm.network "forwarded_port", host: 3000, guest: 3000
  config.vm.network "forwarded_port", host: 8000, guest: 80

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # A private dhcp network is required for NFS to work (on Windows hosts, at least)
  config.vm.network "private_network", ip: "192.168.33.10"

  # Disable default vagrant share folder.
  # config.vm.synced_folder "", "/vagrant", disabled: true
  #
  # # Add additional synced folders to unversioned 'synced_folders' file
  #  if File.exist?('./synced_folders')
  #    synced_folders = File.read 'synced_folders'
  #    eval synced_folders
  #  end

  # Have synced folders in vagrant directory
  config.vm.synced_folder "./", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name = "nusskylab"
    vb.memory = "1024"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision :shell, path: "bootstrap.sh", privileged: false
end
