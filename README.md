mongoDB Cookbook
================
This cookbook installs and provides resources for managing a mongoDB installation on Linux Debian


Dependencies
------------
This cookbook depends on the following community cookbook:

`apt`


Attributes
----------
#### spinen-mongoDB::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mongodb']['data_directory']</tt></td>
    <td>String</td>
    <td>A Directory that stores the database files and should be backed up</td>
    <td><tt>/var/lib/mongodb</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['binding']['ipaddress']</tt></td>
    <td>String</td>
    <td>The IP Address that mongodb will bind to</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['binding']['port']</tt></td>
    <td>String</td>
    <td>the port that mongodb will use for connections</td>
    <td><tt>27017</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['log']['directory']</tt></td>
    <td>String</td>
    <td>The Directory that mongodb will drop it's logs. See other logging options if interested</td>
    <td><tt>/var/log/mongodb</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['requires_authentication']</tt></td>
    <td>Boolean</td>
    <td>Controls whether or not authentication should be used for connection to MongoDB</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['user_admin_username']</tt></td>
    <td>String</td>
    <td>The Username that we create if authentication is used, this user will be given the 
      'userAdminAnyDatabase' role so that it can create and manage users for us</td>
    <td><tt>useradmin</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['user_admin_password']</tt></td>
    <td>String</td>
    <td>The Password given to the above user. !!Keep it safe!!</td>
    <td><tt>abc123</tt></td>
  </tr>
  <tr>
    <td><tt>['mongodb']['name_collection']</tt></td>
    <td>String</td>
    <td>The name of the default collection used to create databases. it creates the 
      database, the default collection, with the name of the database</td>
    <td><tt>:name</tt></td>
  </tr>
</table>


Resources
---------
This Cookbook includes 3 new resources for your mongodb needs:

#### mongodb_database

##### Actions
- :create : Creates the requested database (Default)
- :drop : Drops the requested database

##### Parameters

- name: the name attribute. the name of the database to be created
- authentication: Whether or not we need to use authentication to create the database
- username: a username with access to read/write the database and the listDatabases role
- password: password for the given user above
- name_collection: the name of the default collection used to create the database
- mongodb_host: the hostname or IP of the mongo instance we're going to create the database on
- mongodb_port: the port of the mongo instance we're going to create the database on

##### Example

```ruby
spinen-mongoDB_database 'testdb' do
  action :create
  authentication true
  username 'rootuser'
  password 'rootpassword'
  name_collection 'dbName'
  mongodb_host 'localhost'
  mongodb_port '27017'
end
```

#### mongodb_collection

##### Actions
- :create : Creates the requested collection on the specified database (Default)
- :drop : Drops the requested collection on the specified database

##### Parameters

- name: the name attribute. the name of the collection to be created
- authentication: Whether or not we need to use authentication to connect to the database
- username: a username with access to read/write the database
- password: password for the given user above
- mongodb_host: the hostname or IP of the mongo instance we're going to create the database on
- mongodb_port: the port of the mongo instance we're going to create the database on
- database: the database that we'll be creating the collection on.

##### Example

```ruby
spinen-mongoDB_collection 'myreallycoolcollection' do
  action :create
  authentication true
  username 'fancyuser'
  password 'fancypassword'
  database 'dbName'
  mongodb_host 'localhost'
  mongodb_port '27017'
end
```



#### mongodb_user

##### Actions
- :create : Creates the requested user on the admin database with given roles (Default)
- :remove : Removes the requested user from the admin database

##### Parameters

- name: the name attribute. the name of the user to be created
- password: the password of the user you want to create
- roles: an array of objects (either hashes, or strings) to represent the roles the user will get.
- useradmin_username: a user admin with permissions to listusers, createusers and deleteusers
- useradmin_password: password for the useradmin user above
- mongodb_host: the hostname or IP of the mongo instance we're going to create the database on
- mongodb_port: the port of the mongo instance we're going to create the database on

##### Example

```ruby
spinen-mongoDB_user 'lreimer' do
  action :create
  useradmin_username 'myUserAdmin'
  useradmin_password 'myAdminPass'
  mongodb_host 'localhost'
  mongodb_port '27017'
  roles [ "root" ]
end
```

```ruby
spinen-mongoDB_user 'lreimer' do
  action :create
  useradmin_username 'myUserAdmin'
  useradmin_password 'myAdminPass'
  mongodb_host 'localhost'
  mongodb_port '27017'
  roles [ {role: "readWrite", db: "testdb" } ]
end
```

License and Authors
-------------------
Authors: Johnny Walker, SPINEN
