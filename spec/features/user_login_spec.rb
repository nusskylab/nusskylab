require 'rails_helper'

feature 'user logs in' do
  user_name = 'user_feature_spec'
  email = 'user1@feature.spec'
  uid = 'user1.feature.spec'
  admin_email = 'admin@feature.spec'
  admin_uid = 'admin.feature.spec'
  non_user_email = 'non_user@feature.spec'
  password = 'password'

  before(:all) do
    User.find_by(email: email) || FactoryGirl.create(:user, user_name: user_name,email: email, uid: uid, password: password)
    admin_user = User.find_by(email: admin_email) || FactoryGirl.create(:user, email: admin_email, uid: admin_uid, password: password)
    Admin.find_by(user_id: admin_user.id) || FactoryGirl.create(:admin, user_id: admin_user.id)
  end

  scenario 'non_logged_in user logs in' do
    visit new_user_session_path
    expect(page).to have_content('Log in')
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content('Welcome, user_feature_spec')
  end

  scenario 'admin user logs in' do
    visit new_user_session_path
    expect(page).to have_content('Log in')
    fill_in 'Email', with: admin_email
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content('You can use navbar above to look around')
  end

  scenario 'non_user user cannot log in' do
    visit new_user_session_path
    expect(page).to have_content('Log in')
    fill_in 'Email', with: non_user_email
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content('Invalid email or password')
  end

  after(:all) do
    user = User.find_by(email: email)
    user.destroy if user
    admin_user = User.find_by(email: admin_email)
    if admin_user
      admin = Admin.find_by(user_id: admin_user.id)
      admin.destroy if admin
      admin_user.destroy
    end
  end
end
