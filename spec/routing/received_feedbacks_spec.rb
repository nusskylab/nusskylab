require 'rails_helper'

RSpec.describe 'routing to milestone team received_feedbacks', :type => :routing do
  it 'routes milestones/:milestone_id/teams/:team_id/received_feedbacks to received_feedbacks#index' do
    expect(get: 'milestones/1/teams/1/received_feedbacks').to route_to(controller: 'received_feedbacks',
                                                                       action: 'index',
                                                                       milestone_id: '1',
                                                                       team_id: '1')
  end
end

