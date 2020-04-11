require 'rails_helper'

RSpec.describe 'routing to milestones', :type => :routing do
  it 'routes /milestones to milestones#index' do
    expect(get: '/milestones').to route_to(controller: 'milestones',
                                           action: 'index')
  end

  it 'routes /milestones/new to milestones#new' do
    expect(get: '/milestones/new').to route_to(controller: 'milestones',
                                               action: 'new')
  end

  it 'routes /milestones/:id/edit to milestones#edit for id' do
    expect(get: '/milestones/1/edit').to route_to(controller: 'milestones',
                                                  action: 'edit',
                                                  id: '1')
  end

  it 'routes /milestones/:id to milestones#update for id' do
    expect(put: '/milestones/1').to route_to(controller: 'milestones',
                                             action: 'update',
                                             id: '1')
  end

  it 'routes /milestones/:id to milestones#show for id' do
    expect(get: '/milestones/1').to route_to(controller: 'milestones',
                                             action: 'show',
                                             id: '1')
  end

  it 'routes /milestones/:id to milestones#destroy for id' do
    expect(delete: '/milestones/1').to route_to(controller: 'milestones',
                                                action: 'destroy',
                                                id: '1')
  end
end


