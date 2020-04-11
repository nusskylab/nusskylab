require 'rails_helper'

RSpec.describe 'routing to advisers', :type => :routing do
  it 'routes /advisers to advisers#index' do
    expect(get: '/advisers').to route_to(controller: 'advisers',
                                         action: 'index')
  end

  it 'routes /advisers/new to advisers#new' do
    expect(get: '/advisers/new').to route_to(controller: 'advisers',
                                             action: 'new')
  end

  it 'routes /advisers/:id to advisers#show for id' do
    expect(get: '/advisers/1').to route_to(controller: 'advisers',
                                           action: 'show',
                                           id: '1')
  end

  it 'routes /advisers/:id to advisers#destroy for id' do
    expect(delete: '/advisers/1').to route_to(controller: 'advisers',
                                              action: 'destroy',
                                              id: '1')
  end
end


