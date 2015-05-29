require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test 'can save a normal user' do
  #   user = User.new(email: 'A0000004@test.com',
  #                   user_name: 'test user',
  #                   uid: 'A0000004',
  #                   provider: 'NUS')
  #   assert user.valid?
  # end
  #
  # test 'can save a user with provider missing, default is NUS' do
  #   user = User.new(email: 'A0000004@test.com',
  #                   user_name: 'A0000004',
  #                   uid: 'A0000004')
  #   assert user.valid?
  # end
  #
  # test 'cannot save a user with user name missing' do
  #   user = User.new(email: 'A0000004@test.com',
  #                   uid: 'A0000004',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
  #
  # test 'cannot save a user with email missing' do
  #   user = User.new(user_name: 'A0000004',
  #                   uid: 'A0000004',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
  #
  # test 'cannot save a user with uid missing' do
  #   user = User.new(email: 'A0000004@test.com',
  #                   user_name: 'A0000004',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
  #
  # test 'cannot save a user with wrong email format' do
  #   user = User.new(email: 'A0000004@test.',
  #                   user_name: 'test user',
  #                   uid: 'A0000004',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
  #
  # test 'cannot save a user with wrong user name format' do
  #   user = User.new(email: 'A0000004@test.',
  #                   user_name: 'a',
  #                   uid: 'A0000004',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
  #
  # test 'cannot save a user with duplicate uid and provider with existing record' do
  #   user = User.new(email: 'A0000004@test.',
  #                   user_name: 'test user',
  #                   uid: 'A0000003',
  #                   provider: 'NUS')
  #   assert_not user.valid?
  # end
end
