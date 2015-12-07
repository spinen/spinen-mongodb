property :authentication, [TrueClass, FalseClass], default: false
property :username, String, default: 'user'
property :password, String, default: 'changeme'
property :mongodb_host, String, default: 'localhost'
property :mongodb_port, String, default: '27017'
property :database, String, default: 'myfancydatabase'




action :create do
  ruby_block name do
    block do
      if authentication
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: database, user: username, password: password)
      else
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: database)
      end
      new_collection = my_database[name]
      new_collection.create()
    end
  end
end


action :drop do
  ruby_block name do
    block do
      if authentication
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: database, user: username, password: password)
      else
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: database)
      end
      new_collection = my_database[name]
      new_collection.drop()
    end
  end
end