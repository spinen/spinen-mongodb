#
# Cookbook Name:: mongoDB
# Recipe:: create_database
#
# Copyright 2015, Specialized Information Environments, INC.
#
# All rights reserved - Do Not Redistribute
#


# install dependencies for the mongo gem
%w(ruby-dev gcc).each do |package_install|
  package package_install do
    action :nothing
  end.run_action :install
end

#Install the mongo gem and then require it for future use
chef_gem 'mongo'
require 'mongo'

ruby_block 'create_the_database' do
  block do
    my_database = Mongo::Client.new([node['mongodb']['binding']['ipaddress'] + ':' + node['mongodb']['binding']['port']], :database => node['mongodb']['database_name'])
    result = my_database[node['mongodb']['name_collection']].insert_one({name: node['mongodb']['database_name']})
  end
end
