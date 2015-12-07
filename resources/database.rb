property :authentication, [TrueClass, FalseClass], default: false
property :username, String, default: 'user'
property :password, String, default: 'changeme'
property :name_collection, String, default: 'name'
property :mongodb_host, String, default: 'localhost'
property :mongodb_port, String, default: '27017'

action :create do
  ruby_block name do
    block do
      if authentication
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: name, user: username, password: password)
      else
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: name)
      end
      
      existing_database_names = my_database.database_names

      my_database[name_collection].insert_one({name: name}) unless existing_database_names.include? name

    end
  end
end

action :drop do
  ruby_block name do
    block do
      if authentication
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: name, user: username, password: password)
      else
        my_database = Mongo::Client.new([mongodb_host + ':' + mongodb_port], database: name)
      end
      my_database.database.drop
    end
  end
end