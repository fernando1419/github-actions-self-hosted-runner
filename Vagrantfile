Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20240821.0.1"
  config.vm.network "private_network", ip: "192.168.50.100"

  config.vm.provision "file", source: "./actions-runner-linux-x64-2.326.0.tar.gz", destination: "/home/vagrant/actions-runner-linux-x64-2.326.0.tar.gz"

  # Ejecutar el script como usuario vagrant (no root)
  config.vm.provision "shell", path: "./scripts/setup-self-hosted-runner.sh", privileged: false

  # SHELL
  config.vm.provider "virtualbox" do |vb|
    vb.name = "ubuntu-focal64_self-hosted-runner"
    vb.memory = "2048"
    vb.cpus = 2
  end
end
