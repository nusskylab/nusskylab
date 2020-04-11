require 'rails_helper'

RSpec.describe 'routing to admins', :type => :routing do
  it 'routes /admins to admins#index' do
    expect(get: '/admins').to route_to(controller: 'admins',
                                       action: 'index')
  end

  it 'routes /admins/new to admins#new' do
    expect(get: '/admins/new').to route_to(controller: 'admins',
                                           action: 'new')
  end

  it 'routes /admins/:id to admins#show for id' do
    expect(get: '/admins/1').to route_to(controller: 'admins',
                                         action: 'show',
                                         id: '1')
  end

  it 'routes /admins/:id to admins#destroy for id' do
    expect(delete: '/admins/1').to route_to(controller: 'admins',
                                            action: 'destroy',
                                            id: '1')
  end
end


