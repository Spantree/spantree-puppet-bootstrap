# -*- mode: ruby -*-
# vi: set ft=ruby :

SUBNET = "192.168.147"
MASTER_IP = "#{SUBNET}.100"
PROJECT_SYNC_ROOT = "/usr/local/src/puppet-bootstrap"

Vagrant.configure("2") do |config|
  # For Ubuntu
  config.vm.box = "ubuntu/trusty64"

  # For CentOS (not yet supported due to lack of Ruby 1.9.1 in yum)
  # config.vm.box = "hansode/centos-6.5-x86_64"

  config.vm.synced_folder '.', PROJECT_SYNC_ROOT, :create => 'true'

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provision :shell, :path => 'shell/initialize-all.sh', :args => '/vagrant/shell'

  config.ssh.username = "vagrant"

  config.ssh.shell = "bash -l"

  config.ssh.keep_alive = true
  config.ssh.forward_agent = false
  config.ssh.forward_x11 = false
  config.vagrant.host = :detect

  config.vm.define :master do |box|
    box.vm.network :private_network, ip: MASTER_IP

    box.vm.provider :virtualbox do |v, override|
      v.customize ["modifyvm", :id, "--memory", 1024]
    end

    box.vm.hostname = "dev.puppetbootstrap.spantree.local"
    box.hostmanager.aliases =  %()

    box.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      puppet.facter = {
        "ssh_username" => "vagrant",
        "host_environment" => "vagrant",
      }
      puppet.options = [
        '--verbose',
        '--debug',
        '--modulepath=/etc/puppet/modules:#{PROJECT_SYNC_ROOT}/puppet/modules',
        "--hiera_config #{PROJECT_SYNC_ROOT}/hiera.yaml",
        "--parser future",
        "--templatedir=#{PROJECT_SYNC_ROOT}/puppet/templates",
      ]
    end
  end
end
