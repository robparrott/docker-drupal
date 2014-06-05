
#
# Setup a shared config from here via environment variables
#

vagrant_insecure_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

env_vars = {
	"MYSQL_DATABASE" => "drupal",
	"MYSQL_USER" => "drupal",
	"MYSQL_PASSWORD" => "SmallSecret",
	"MYSQL_ROOT_PASSWORD" => "BigSecret",
	"MEMCACHED_USER" => "admin",
    "MEMCACHED_PASS" => "CachedSecret",
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
      #d.has_ssh = "true"
    end
  end

  config.vm.define "memcached" do |memcached|
  	memcached.vm.boot_timeout = 60
    memcached.vm.provider "docker" do |d|
      d.build_dir = "memcached"
      d.name = "memcached"
      d.ports = ["11211:11211"]
      d.env = env_vars
      #d.has_ssh = "true"
    end
  end

  config.vm.define "drupal" do |drupal|
    drupal.vm.provider "docker" do |d|    
      d.build_dir = "drupal"
      d.name = "drupal"
      d.ports = ["8090:80", "2200:22"]
      d.env = env_vars
      #d.has_ssh = "true"
      d.link("mysql:db")
      d.link("memcached:memcached")
    end
  end

  config.vm.define "varnish" do |varnish|
    varnish.vm.provider "docker" do |d|    
      d.build_dir = "varnish"
      d.name = "varnish"
      d.ports = ["8080:80"]  
      #d.has_ssh = "true"
      d.link("drupal:drupal")
    end
  end

end
