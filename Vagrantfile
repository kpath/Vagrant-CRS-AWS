# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # we're not using a real box.  we're using an amazon AMI
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.ssh.pty = true
  config.ssh.username = "root"
  config.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']

  config.vm.provider :aws do |aws|
    # RightImage_CentOS_6.5_x64_v14.1_EBS
    aws.ami = "ami-b41ebfdc"

    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    aws.security_groups = ["ssh-allowed-anywhere"]
    
    aws.instance_type = "m3.xlarge"
    aws.block_device_mapping = [
      { 
        'DeviceName' => '/dev/sda1',
        'Ebs.VolumeSize' => 50 
      },
      {
        "DeviceName" => "/dev/xvdk",
        "Ebs.SnapshotId" => "snap-85a3e722"
      }
    ]
  end

  # provision
  config.vm.provision "shell" do |s|
      s.path = "scripts/provision.sh"
      s.args = ENV['PROVISION_ARGS']
  end

end
