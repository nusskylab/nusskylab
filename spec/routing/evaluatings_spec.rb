require 'rails_helper'

RSpec.describe 'routing to evaluatings', :type => :routing do
  it 'routes /evaluatings to evaluatings#index' do
    expect(get: '/evaluatings').to route_to(controller: 'evaluatings',
                                            action: 'index')
  end

  it 'routes /evaluatings/new to evaluatings#new' do
    expect(get: '/evaluatings/new').to route_to(controller: 'evaluatings',
                                                action: 'new')
  end

  it 'routes /evaluatings/:id/edit to evaluatings#edit for id' do
    expect(get: '/evaluatings/1/edit').to route_to(controller: 'evaluatings',
                                                   action: 'edit',
                                                   id: '1')
  end

  it 'routes /evaluatings/:id to evaluatings#update for id' do
    expect(put: '/evaluatings/1').to route_to(controller: 'evaluatings',
                                              action: 'update',
                                              id: '1')
  end

  it 'routes /evaluatings/:id to evaluatings#destroy for id' do
    expect(delete: '/evaluatings/1').to route_to(controller: 'evaluatings',
                                                 action: 'destroy',
                                                 id: '1')
  end
end


