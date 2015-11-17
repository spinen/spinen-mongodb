#
# Cookbook Name:: mongoDB
# Recipe:: default
#
# Copyright 2015, Specialized Information Environments, INC.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

apt_repository 'mongodb-org-3.0' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'trusty/mongodb-org/3.0'
  components ['multiverse']
  key '7F0CEB10'
  keyserver 'hkp://keyserver.ubuntu.com:80'
  action :add
 end


if node.default['mongodb']['installTools']
  package 'mongodb-org' do
    action :install
  end
else
  package 'mongodb-org-server' do
    action :install
  end
  package 'mongodb-org-shell' do
    action :install
  end
end

service 'mongod' do
  supports :status => true, :restart => true
  action [:start, :enable]
end


template '/etc/mongod.conf' do
  source 'mongod.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[mongod]', :delayed
  variables(
  	:dbpath => node['mongodb']['data_directory'],
  	:enable_journaling => node['mongodb']['enable_journaling'],
  	:binding_port => node['mongodb']['binding']['port'],
  	:binding_ipaddress => node['mongodb']['binding']['ipaddress'],
  	:log_destination => node['mongodb']['log']['destination'],
  	:log_append => node['mongodb']['log']['append'],
  	:log_directory => node['mongodb']['log']['directory'],
  	:log_name => node['mongodb']['log']['file_name'],
  	:log_rotate => node['mongodb']['log']['rotate'],
  	:log_rotate_option => node['mongodb']['log']['rotate_option']
  )
end



#now we need to own the config file located at /etc/mongod.conf
#we need to make attributes for storage and log locations as well
#as the port and bindingIP


#Do this kinda stuff maybe:
#https://docs.mongodb.org/manual/administration/production-notes/

