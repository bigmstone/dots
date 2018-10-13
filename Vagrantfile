# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.allowed_synced_folder_types = [:rsync]

  config.vm.provider "aws" do |aws, override|
    aws.tags = {
      'Name' => 'DevBox'
    }
    aws.associate_public_ip = true
    aws.instance_type = 't2.medium'
    aws.ami = 'ami-0ac019f4fcb7cb7e6'
    aws.subnet_id = 'subnet-3b642f5e'
    aws.keypair_name = 'mstone'
    aws.security_groups = ['sg-725fe838']

    override.ssh.username = 'ubuntu'
    override.ssh.private_key_path = '~/.ssh/mstone.pem'
  end

  config.vm.provision "shell", inline: "sudo apt-get update; sudo apt-get -y install python python-setuptools"

  config.vm.provision "ansible" do |ansible|
    ansible.config_file = "~/dev/dots/ansible/config.cfg"
    ansible.playbook = "ansible/main.yml"
  end
end
