require 'rails_helper'

RSpec.describe 'routing to team peer_evaluations', :type => :routing do
  it 'routes milestones/:milestone_id/teams/:team_id/peer_evaluations/new to peer_evaluations#new' do
    expect(get: 'milestones/1/teams/1/peer_evaluations/new').to route_to(controller: 'peer_evaluations',
                                                                         action: 'new',
                                                                         milestone_id: '1',
                                                                         team_id: '1')
  end

  it 'routes milestones/:milestone_id/teams/:team_id/peer_evaluations to peer_evaluations#create' do
    expect(post: 'milestones/1/teams/1/peer_evaluations').to route_to(controller: 'peer_evaluations',
                                                                      action: 'create',
                                                                      milestone_id: '1',
                                                                      team_id: '1')
  end

  it 'routes milestones/:milestone_id/teams/:team_id/peer_evaluations/:id/edit to peer_evaluations#edit for id' do
    expect(get: 'milestones/1/teams/1/peer_evaluations/1/edit').to route_to(controller: 'peer_evaluations',
                                                                            action: 'edit',
                                                                            milestone_id: '1',
                                                                            team_id: '1',
                                                                            id: '1')
  end

  it 'routes milestones/:milestone_id/teams/:team_id/peer_evaluations/:id to peer_evaluations#update for id' do
    expect(put: 'milestones/1/teams/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                                       action: 'update',
                                                                       milestone_id: '1',
                                                                       team_id: '1',
                                                                       id: '1')
  end

  it 'routes milestones/:milestone_id/teams/:team_id/peer_evaluations/:id to peer_evaluations#show for id' do
    expect(get: 'milestones/1/teams/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                                       action: 'show',
                                                                       milestone_id: '1',
                                                                       team_id: '1',
                                                                       id: '1')
  end



  it 'routes milestones/:milestone_id/adviser/:adviser_id/peer_evaluations/new to peer_evaluations#new' do
    expect(get: 'milestones/1/advisers/1/peer_evaluations/new').to route_to(controller: 'peer_evaluations',
                                                                            action: 'new',
                                                                            milestone_id: '1',
                                                                            adviser_id: '1')
  end

  it 'routes milestones/:milestone_id/adviser/:adviser_id/peer_evaluations to peer_evaluations#create' do
    expect(post: 'milestones/1/advisers/1/peer_evaluations').to route_to(controller: 'peer_evaluations',
                                                                         action: 'create',
                                                                         milestone_id: '1',
                                                                         adviser_id: '1')
  end

  it 'routes milestones/:milestone_id/adviser/:adviser_id/peer_evaluations/:id/edit to peer_evaluations#edit for id' do
    expect(get: 'milestones/1/advisers/1/peer_evaluations/1/edit').to route_to(controller: 'peer_evaluations',
                                                                               action: 'edit',
                                                                               milestone_id: '1',
                                                                               adviser_id: '1',
                                                                               id: '1')
  end

  it 'routes milestones/:milestone_id/adviser/:adviser_id/peer_evaluations/:id to peer_evaluations#update for id' do
    expect(put: 'milestones/1/advisers/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                                          action: 'update',
                                                                          milestone_id: '1',
                                                                          adviser_id: '1',
                                                                          id: '1')
  end

  it 'routes milestones/:milestone_id/adviser/:adviser_id/peer_evaluations/:id to peer_evaluations#show for id' do
    expect(get: 'milestones/1/advisers/1/peer_evaluations/1').to route_to(controller: 'peer_evaluations',
                                                                          action: 'show',
                                                                          milestone_id: '1',
                                                                          adviser_id: '1',
                                                                          id: '1')
  end
end

