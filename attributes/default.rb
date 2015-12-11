#
# Cookbook Name:: mongodb
# Attribute file:: default
#
# Copyright (C) 2015 SPINEN
#
# Licensed under the MIT license.
# A copy of this license is provided at the root of this cookbook.
#

default['mongodb']['install_tools']			       =	true

default['mongodb']['data_directory']		       =	'/var/lib/mongodb'
default['mongodb']['enable_journaling']        =	true

default['mongodb']['binding']['port']          =	'27017'
default['mongodb']['binding']['ipaddress']	   =	'127.0.0.1'

default['mongodb']['log']['destination']	     =	'file'
default['mongodb']['log']['append']	           =	true
default['mongodb']['log']['directory']		     =	'/var/log/mongodb'
default['mongodb']['log']['file_name']		     =	'mongod.log'
default['mongodb']['log']['rotate']	           =	true
default['mongodb']['log']['rotate_option']     =	'rename'

# Shall we require auth?
default['mongodb']['requires_authentication']  = false
default['mongodb']['user_admin_username']      = 'useradmin'
default['mongodb']['user_admin_password']      = 'abc123'

# standard convention is to use the name collection
# to create the database, use something else if you wish.
default['mongodb']['name_collection']          = ':name'
