property :password, String, default: 'changeme'
property :roles, Array, default: [ {role: "readWrite", db: "test" } ]
property :useradmin_username, String, default: 'user'
property :useradmin_password, String, default: 'changeme'
property :mongodb_host, String, default: 'localhost'
property :mongodb_port, String, default: '27017'



action :create do

ruby_block name do
    block do
      mongo_user_client = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: 'admin', user: useradmin_username, password: useradmin_password)

      currUser = mongo_user_client.database.users.info(name)

      mongo_user_client.database.users.create(name, password: password, roles: roles) if currUser.empty?

    end
  end

end


action :remove do

ruby_block name do
    block do
      mongo_user_client = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: 'admin', user: useradmin_username, password: useradmin_password)
      mongo_user_client.database.users.remove(name)
    end
  end


end
