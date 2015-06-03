FactoryGirl.define do
  factory :user do
    email 'test1@gmail.com'
    user_name 'test user1'
    provider 'NUS'
    uid 'https://openid.nus.edu.sg/a0000001'
    password 'password'
  end
end
