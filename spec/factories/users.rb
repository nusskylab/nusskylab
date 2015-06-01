FactoryGirl.define do
  factory :user do |f|
    f.email 'test1@example.com'
    f.user_name 'test user1'
    f.provider 'NUS'
    f.uid 'https://openid.nus.edu.sg/a0000001'
    f.password 'password'
  end
end
