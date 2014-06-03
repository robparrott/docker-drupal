Vagrant.configure("2") do |config|
  
  config.vm.define "mysql" do |mysql|
  	mysql.vm.boot_timeout = 60
    mysql.vm.provider "docker" do |d|
      d.build_dir = "mysql"
      d.name = "mysql"
      d.ports = ["3306:3306"]
#      d.has_ssh = "true"
    end
  end

  config.vm.define "drupal" do |drupal|
    drupal.vm.provider "docker" do |d|    
      d.build_dir = "drupal"
      d.name = "web"
      d.ports = ["8080:80", "2200:22"]
      d.env = { "MYSQL_HOST" => "172.17.0.3" }
#      d.has_ssh = "true"
      d.link("mysql:db")
    end
  end

  # config.vm.define "varnish" do |varnish|
  #   varnish.vm.provider "docker" do |d|    
  #     d.build_dir = "varnish"
  #     d.ports = ["8080:80", "2202:22"]  
  #     d.has_ssh = "true"
  #     d.link("drupal:drupal")
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
