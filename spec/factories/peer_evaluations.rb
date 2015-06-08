FactoryGirl.define do
  factory :peer_evaluation do
    project_log 'project log'
    read_me 'project read me'
    video_link 'http://haha.com'
    team
    milestone
  end
end
