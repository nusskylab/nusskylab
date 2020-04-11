require 'rails_helper'

RSpec.describe 'routing to users', :type => :routing do
  it 'routes /users to users#index' do
    expect(get: '/users').to route_to(controller: 'users',
                                      action: 'index')
  end

  it 'routes /users/:id to users#show for id' do
    expect(get: '/users/1').to route_to(controller: 'users',
                                        action: 'show',
                                        id: '1')
  end

  it 'routes /users/new to users#new' do
    expect(get: '/users/new').to route_to(controller: 'users',
                                          action: 'new')
  end

  it 'routes /users to users#create' do
    expect(post: '/users').to route_to(controller: 'users',
                                       action: 'create')
  end

  it 'routes /users/:id/edit to users#edit for id' do
    expect(get: '/users/1/edit').to route_to(controller: 'users',
                                             action: 'edit',
                                             id: '1')
  end

  it 'routes /users/:id to users#update for id' do
    expect(put: '/users/1').to route_to(controller: 'users',
                                        action: 'update',
                                        id: '1')
  end

  it 'routes /users/:id/preview_as to users#update for id' do
    expect(post: '/users/1/preview_as').to route_to(controller: 'users',
                                                    action: 'preview_as',
                                                    id: '1')
  end

  it 'routes /users/:id to users#destroy for id' do
    expect(delete: '/users/1').to route_to(controller: 'users',
                                           action: 'destroy',
                                           id: '1')
  end
end


