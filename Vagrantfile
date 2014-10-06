Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "monorail"
  config.vm.network "forwarded_port", guest: 3000, host: 8070
 # config.vm.network "private_network", ip: "192.168.1.199"

  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 2
  end
end

