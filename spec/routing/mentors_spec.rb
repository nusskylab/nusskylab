require 'rails_helper'

RSpec.describe 'routing to mentors', :type => :routing do
  it 'routes /mentors to mentors#index' do
    expect(get: '/mentors').to route_to(controller: 'mentors',
                                        action: 'index')
  end

  it 'routes /mentors/new to mentors#new' do
    expect(get: '/mentors/new').to route_to(controller: 'mentors',
                                            action: 'new')
  end

  it 'routes /mentors/:id to mentors#show for id' do
    expect(get: '/mentors/1').to route_to(controller: 'mentors',
                                          action: 'show',
                                          id: '1')
  end

  it 'routes /mentors/:id to mentors#destroy for id' do
    expect(delete: '/mentors/1').to route_to(controller: 'mentors',
                                             action: 'destroy',
                                             id: '1')
  end
end


