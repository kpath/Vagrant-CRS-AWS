# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# NOTE! change this at your own risk.  The CRS demo might run on a smaller instance, but it might not
AWS_INSTANCE_TYPE = "m3.xlarge"

# You can change this if you want, but it should be to another centos 6.5 image
# RightImage_CentOS_6.5_x64_v14.1_EBS
AWS_AMI = "ami-b41ebfdc"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # we're not using a real box.  we're using an amazon AMI
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.ssh.pty = true
  config.ssh.username = "root"
  config.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']

  config.vm.provider :aws do |aws|

    aws.ami = AWS_AMI

    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    aws.security_groups = ENV['AWS_SECURITY_GROUP']
    
    aws.instance_type = AWS_INSTANCE_TYPE
    aws.block_device_mapping = [
      { 
        'DeviceName' => '/dev/sda1',
        'Ebs.VolumeSize' => 50 
      },
      {
        "DeviceName" => "/dev/xvdk",
        "Ebs.SnapshotId" => ENV['AWS_SOFTWARE_SNAPSHOT']
      }
    ]
  end

  # provision
  config.vm.provision "shell" do |s|
      s.path = "scripts/provision.sh"
      s.args = ENV['PROVISION_ARGS']
  end

end
