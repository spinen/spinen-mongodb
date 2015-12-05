property :name, String, default: 'mydatabase'
property :authentication, [TrueClass, FalseClass], default: false
property :username, String, default: 'user'
property :password, String, default: 'changeme'
property :name_collection, String, default: 'name'



action :create do

  ruby_block 'create_the_database' do
    block do
      my_database = Mongo::Client.new([node['mongodb']['binding']['ipaddress'] + ':' + node['mongodb']['binding']['port']], :database => name)
      result = my_database[name_collection].insert_one({name: name})
    end
  end

end

action :drop do

end

action :blah do