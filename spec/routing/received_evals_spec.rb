require 'rails_helper'

RSpec.describe 'routing to milestone team received_evals', :type => :routing do
  it 'routes milestones/:milestone_id/teams/:team_id/received_evals to received_evals#index' do
    expect(get: 'milestones/1/teams/1/received_evals').to route_to(controller: 'received_evals',
                                                                   action: 'index',
                                                                   milestone_id: '1',
                                                                   team_id: '1')
  end
end

