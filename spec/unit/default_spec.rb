require 'chefspec'

describe 'mongodb::default' do
  it 'includes the APT Recipe' do
    expect(chef_run).to include_recipe 'apt:default'
  end
end
