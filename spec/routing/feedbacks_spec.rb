require 'rails_helper'

RSpec.describe 'routing to feedbacks', :type => :routing do
  it 'routes teams/:team_id/feedbacks/new to feedbacks#new' do
    expect(get: 'teams/1/feedbacks/new').to route_to(controller: 'feedbacks',
                                                     action: 'new',
                                                     team_id: '1')
  end

  it 'routes teams/:team_id/feedbacks to feedbacks#create' do
    expect(post: 'teams/1/feedbacks').to route_to(controller: 'feedbacks',
                                                  action: 'create',
                                                  team_id: '1')
  end

  it 'routes teams/:team_id/feedbacks/:id/edit to feedbacks#edit for id' do
    expect(get: 'teams/1/feedbacks/1/edit').to route_to(controller: 'feedbacks',
                                                        action: 'edit',
                                                        team_id: '1',
                                                        id: '1')
  end

  it 'routes teams/:team_id/feedbacks/:id to feedbacks#update for id' do
    expect(put: 'teams/1/feedbacks/1').to route_to(controller: 'feedbacks',
                                                   action: 'update',
                                                   team_id: '1',
                                                   id: '1')
  end
end


