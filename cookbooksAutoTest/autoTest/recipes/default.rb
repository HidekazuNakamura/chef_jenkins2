#
# Cookbook Name:: autoTest
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{java java-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/jenkins-1.538-1.1.noarch.rpm" do 
  not_if{File.exists?("#{Chef::Config[:file_cache_path]}/jenkins-1.538-1.1.noarch.rpm")}
  source "http://pkg.jenkins-ci.org/redhat/jenkins-1.538-1.1.noarch.rpm"
end
 
rpm_package "jenkins" do
  source "#{Chef::Config[:file_cache_path]}/jenkins-1.538-1.1.noarch.rpm"
end

service "jenkins" do
  action [:enable, :start]
end

package "php-pear" do
  action:install
end

execute "channel-discover pear.phing.info" do
  not_if{File.exists?("/usr/share/pear/.channels/pear.phing.info.reg")}
  action :run
  command 'pear channel-discover pear.phing.info'
end

execute "channel-discover pear.phpunit.de" do
  not_if{File.exists?("/usr/share/pear/.channels/pear.php.net.reg")}
  action :run
  command 'pear channel-discover pear.phpunit.de'
end

execute "channel-discover components.ez.no" do
  not_if{File.exists?("/usr/share/pear/.channels/components.ez.no.reg")}
  action :run
  command 'pear channel-discover components.ez.no'
end

execute "channel-discover pear.symfony-project.com" do
  not_if{File.exists?("/usr/share/pear/.channels/pear.symfony-project.com.reg")}
  action :run
  command 'pear channel-discover pear.symfony-project.com'
end

execute "phing/phing" do
  not_if'which phing'
  command 'pear install phing/phing'
  action :run
end

package "php-dom" do
  action:install
end

execute "channel-discover pear.phpunit.de" do
  not_if{File.exists?("/usr/share/pear/.channels/pear.php.net.reg")}
  action :run
  command 'pear channel-discover pear.phpunit.de'
end

execute "config-set auto_discover 1" do
  action :run
  command 'pear config-set auto_discover 1'
end

execute "upgrade pear" do
  action :run
  command 'pear upgrade pear'
end

execute "phpunit/PHPUnit" do
  not_if'which phpunit'
  command 'pear install phpunit/PHPUnit'
  action :run
end

execute "phpunit/PHPUnit_Selenium" do
  not_if'which phpunit'
  command 'pear install phpunit/PHPUnit_Selenium'
  action :run
end

remote_file "#{Chef::Config[:jenkins_path]}/jenkins-cli.jar" do
  not_if{File.exists?("#{Chef::Config[:jenkins_path]}/jenkins-cli.jar")}

  source "http://localhost:8080/jnlpJars/jenkins-cli.jar"
end

execute "get jenkins_plugin" do
  not_if{File.exists?("#{Chef::Config[:jenkins_path]}/jenkins-cli.jar")}
  command "sudo wget -O #{Chef::Config[:jenkins_path]}/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar"
end

execute "jenkins_plugin" do
  action :run
command "sudo java -jar #{Chef::Config[:jenkins_path]}/jenkins-cli.jar -s http://localhost:8080 install-plugin phing"
end

execute "jenkins_restart" do
  action :run
command "/etc/init.d/jenkins restart"
end

remote_file "#{Chef::Config[:jenkins_opt_path]}/selenium-server-standalone-2.37.0.jar" do
  not_if{File.exists?("#{Chef::Config[:jenkins_opt_path]}/selenium-server-standalone-2.37.0.jar")}
  source "http://selenium.googlecode.com/files/selenium-server-standalone-2.37.0.jar"
end

###
# PHPUnit
###
%w{php php-xml php-mbstring php-gd php-mysql php-pdo}.each do |pkg|
 package pkg do
    action :install
  end
end

#package "php-pear" do
#  action:install
#end

#package "php-mcrypt" do
#  action:install
#end

%w{php-devel gcc make}.each do |pkg|
  package pkg do
    action :install
  end
end

#execute "config-set auto_discover 1" do
#  action :run
#  command 'pear config-set auto_discover 1'
#end

#execute "upgrade pear" do
#  action :run
#  command 'pear upgrade pear'
#end

#execute "channel-discover pear.phpunit.de" do
#  not_if{File.exists?("/usr/share/pear/.channels/pear.php.net.reg")}
#  action :run
#  command 'pear channel-discover pear.phpunit.de'
#end

#execute "phpunit/PHPUnit" do
#  not_if'which phpunit'
#  command 'pear install phpunit/PHPUnit'
#  action :run
#end

#execute "phpunit/PHPUnit_Selenium" do
#  not_if'which phpunit'
#  command 'pear install phpunit/PHPUnit_Selenium'
#  action :run
#end

remote_file "#{Chef::Config[:jenkins_opt_path]}/php-webdriver-bindings-0.9.0.zip" do
  not_if{File.exists?("#{Chef::Config[:jenkins_opt_path]}/php-webdriver-bindings-0.9.0.zip")}
  source "http://php-webdriver-bindings.googlecode.com/files/php-webdriver-bindings-0.9.0.zip"
end

execute "php-webdriver-bindings" do
  not_if{File.exists?("#{Chef::Config[:jenkins_opt_path]}/php-webdriver-bindings-0.9.0/phpwebdriver/WebDriver.php")}

  command "unzip #{Chef::Config[:jenkins_opt_path]}/php-webdriver-bindings-0.9.0.zip"
  action :run
end

