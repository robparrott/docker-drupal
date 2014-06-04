
#
# Setup a shared config from here via environment variables
#

vagrant_insecure_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

env_vars = {
	"MYSQL_DATABASE" => "drupal",
	"MYSQL_USER" => "drupal",
	"MYSQL_PASSWORD" => "SmallSecret",
	"MYSQL_ROOT_PASSWORD" => "BigSecret",
	"ROOT_PASSWORD" => "passw0rd",
	"SSH_PUB_KEY" => vagrant_insecure_public_key
}

Vagrant.configure("2") do |config|
  
  config.vm.define "mysql" do |mysql|
  	mysql.vm.boot_timeout = 60
    mysql.vm.provider "docker" do |d|
      d.build_dir = "mysql"
      d.name = "mysql"
      d.ports = ["3306:3306"]
      d.env = env_vars
#      d.has_ssh = "true"
    end
  end

  config.vm.define "drupal" do |drupal|
    drupal.vm.provider "docker" do |d|    
      d.build_dir = "drupal"
      d.name = "drupal"
      d.ports = ["8080:80", "2200:22"]
      d.env = env_vars
#      d.has_ssh = "true"
      d.link("mysql:db")
    end
  end

  # config.vm.define "varnish" do |varnish|
  #   varnish.vm.provider "docker" do |d|    
  #     d.build_dir = "varnish"
  #     d.ports = ["8080:80", "2202:22"]  
  #     d.has_ssh = "true"
  #     d.link("web:web")
  #   end
  # end

#   config.vm.define "terminal" do |terminal|
#     terminal.vm.provider "docker" do |d|    
#       d.image = "dockeruser/sshd"	
#       d.has_ssh = "true"
#       d.ports = ["22:2222"]
# #      d.link("mysql:db")
#     end
#   end

end
