require 'spec_helper.rb'

describe 'mongoDB::default' do
  let(:chef_run) do 
    ChefSpec::ServerRunner.new do |node|
      node.set['mongodb']['install_tools'] = true
    end.converge('mongoDB::default') 
  end

  it 'includes the apt cookbook' do
    expect(chef_run).to include_recipe 'apt'
  end


  it 'writes the mongodb config file and notifies mongod' do
    expect(chef_run).to create_template('/etc/mongod.conf')

    template = chef_run.template('/etc/mongod.conf')

    expect(template).to notify('service[mongod]').to(:restart).delayed
  end


  it 'adds the official mongodb repository' do
    expect(chef_run).to add_apt_repository('mongodb-org-3.0').with(
      :uri => 'http://repo.mongodb.org/apt/ubuntu',
      :distribution => 'trusty/mongodb-org/3.0'
      )
  end


  it 'starts and enables the mongod service' do
    expect(chef_run).to start_service('mongod')
  end


  it 'Installs the full mongodb suite' do
    expect(chef_run).to install_package('mongodb-org')
    expect(chef_run).to_not install_package('mongodb-org-server')
    expect(chef_run).to_not install_package('mongodb-org-shell')
  end

end



describe 'mongoDB::default' do
  let(:chef_run) do 
    ChefSpec::ServerRunner.new do |node|
      node.set['mongodb']['install_tools'] = false
    end.converge('mongoDB::default') 
  end


  it 'only installs server and shell when requested' do
    expect(chef_run).to install_package('mongodb-org-server')
    expect(chef_run).to install_package('mongodb-org-shell')
    expect(chef_run).to_not install_package('mongodb-org')
  end


end
