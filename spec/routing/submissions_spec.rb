require 'rails_helper'

RSpec.describe 'routing to team submissions', :type => :routing do
  it 'routes teams/:team_id/submissions/:id to submissions#show for id' do
    expect(get: 'teams/1/submissions/1').to route_to(controller: 'submissions',
                                                     action: 'show',
                                                     team_id: '1',
                                                     id: '1')
  end

  it 'routes teams/:team_id/submissions/new to submissions#new' do
    expect(get: 'teams/1/submissions/new').to route_to(controller: 'submissions',
                                                       action: 'new',
                                                       team_id: '1')
  end

  it 'routes teams/:team_id/submissions to submissions#create' do
    expect(post: 'teams/1/submissions').to route_to(controller: 'submissions',
                                                    action: 'create',
                                                    team_id: '1')
  end

  it 'routes teams/:team_id/submissions/:id/edit to submissions#edit for id' do
    expect(get: 'teams/1/submissions/1/edit').to route_to(controller: 'submissions',
                                                          action: 'edit',
                                                          team_id: '1',
                                                          id: '1')
  end

  it 'routes teams/:team_id/submissions/:id to submissions#update for id' do
    expect(put: 'teams/1/submissions/1').to route_to(controller: 'submissions',
                                                     action: 'update',
                                                     team_id: '1',
                                                     id: '1')
  end
end

