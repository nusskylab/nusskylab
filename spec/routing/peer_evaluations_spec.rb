require 'rails_helper'

RSpec.describe 'routing to team peer_evaluations', :type => :routing do
  it 'routes teams/:team_id/peer_evaluations/new to peer_evaluations#new' do
    expect(get: 'teams/1/peer_evaluations/new').to route_to(controller: 'peer_evaluations',
                                                            action: 'new',
                                                            team_id: '1')
  end

  it 'routes teams/:team_id/peer_evaluations to peer_evaluations#create' do
    expect(post: 'teams/1/peer_evaluations').to route_to(controller: 'peer_evaluations',
                                                         action: 'create',
                                                         team_id: '1')
  end

  it 'routes teams/:team_id/peer_evaluations/:id/edit to peer_evaluations#edit for id' do
    expect(get: 'teams/1/peer_evaluations/1/edit').to route_to(controller: 'peer_evaluations',
                                                               action: 'edit',
                                                               team_id: '1',
                                                               id: '1')
  end

  it 'routes teams/:team_id/peer_evaluations/:id to peer_evaluations#update for id' do
    expect(put: 'teams/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                          action: 'update',
                                                          team_id: '1',
                                                          id: '1')
  end

  it 'routes teams/:team_id/peer_evaluations/:id to peer_evaluations#show for id' do
    expect(get: 'teams/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                          action: 'show',
                                                          team_id: '1',
                                                          id: '1')
  end
end

