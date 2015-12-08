#
# Cookbook Name:: mongoDB
# Recipe:: default
#
# Copyright 2015, Specialized Information Environments, INC.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

# Add the official MongoDB Repo
apt_repository 'mongodb-org-3.0' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'trusty/mongodb-org/3.0'
  components ['multiverse']
  key '7F0CEB10'
  keyserver 'hkp://keyserver.ubuntu.com:80'
  action :add
end

# install dependencies for the mongo gem
%w(ruby-dev gcc).each do |package_install|
  package package_install do
    action :nothing
  end.run_action :install
end

# Install the mongo gem and then require it for future use
chef_gem 'mongo'
require 'mongo'

# IF the user wants the dev tools, install everything, otherwise just the server and shell
if node['mongodb']['install_tools']
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

# Enable and Start the service, also make sure chef can ref it later
service 'mongod' do
  supports status: true, restart: true
  action [:start, :enable]
end

# push the mongoDB general configuration, restart mongod if changed
template '/etc/mongod.conf' do
  source 'mongod.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[mongod]', :delayed
  variables(
    dbpath: node['mongodb']['data_directory'],
    enable_journaling: node['mongodb']['enable_journaling'],
    binding_port: node['mongodb']['binding']['port'],
    binding_ipaddress: node['mongodb']['binding']['ipaddress'],
    log_destination: node['mongodb']['log']['destination'],
    log_append: node['mongodb']['log']['append'],
    log_directory: node['mongodb']['log']['directory'],
    log_name: node['mongodb']['log']['file_name'],
    log_rotate: node['mongodb']['log']['rotate'],
    log_rotate_option: node['mongodb']['log']['rotate_option'],
    requires_auth: node['mongodb']['requires_authentication']
  )
end



ruby_block 'enable_authentication' do
  block do
    mongo_client = Mongo::Client.new([node['mongodb']['binding']['ipaddress'] + ':' + node['mongodb']['binding']['port']], database: 'admin')
    mongo_client.database.users.create(node['mongodb']['user_admin_username'], password: node['mongodb']['user_admin_password'], roles: [ "userAdminAnyDatabase" ])
    
  end
  only_if { node['mongodb']['requires_authentication'] }
end










mongoDB_database 'testdb' do
  action :create
end


mongoDB_collection 'mynewcollection' do
  action :create
  database 'testdb'
end