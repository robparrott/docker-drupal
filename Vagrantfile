Vagrant.configure("2") do |config|
  
  config.vm.define "mysql" do |mysql|
    mysql.vm.provider "docker" do |d|
      d.build_dir = "mysql"
      d.has_ssh = "true"
    end
  end

  config.vm.define "drupal" do |drupal|
    drupal.vm.provider "docker" do |d|    
      d.build_dir = "drupal"
      d.has_ssh = "true"
      d.link("mysql")
    end
  end

  config.vm.define "varnish" do |varnish|
    varnish.vm.provider "docker" do |d|    
      d.build_dir = "varnish"
      d.has_ssh = "true"
      d.link("drupal")
    end
  end

end
