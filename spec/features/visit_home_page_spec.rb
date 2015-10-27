require 'rails_helper'

feature 'Visit home page' do
  scenario 'non_logged_in user visits home page' do
    visit root_path
    expect(page).to have_content('What is Orbital?')
  end
end
