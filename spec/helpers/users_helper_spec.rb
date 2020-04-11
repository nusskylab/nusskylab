require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  it '#user_admin?' do
    user = FactoryGirl.create(:user, email: '1@user.helper.spec', uid: '1.user.helper.spec')
    expect(helper.user_admin?).to be_nil
    assign(:user, user)
    expect(helper.user_admin?).to be_nil
    FactoryGirl.create(:admin, user_id: user.id)
    expect(helper.user_admin?).not_to be_nil
  end

  it '#user_adviser?' do
    user = FactoryGirl.create(:user, email: '1@user.helper.spec', uid: '1.user.helper.spec')
    expect(helper.user_adviser?).to be_nil
    assign(:user, user)
    expect(helper.user_adviser?).to be_nil
    FactoryGirl.create(:adviser, user_id: user.id)
    expect(helper.user_adviser?).not_to be_nil
  end

  it '#user_mentor?' do
    user = FactoryGirl.create(:user, email: '1@user.helper.spec', uid: '1.user.helper.spec')
    expect(helper.user_mentor?).to be_nil
    assign(:user, user)
    expect(helper.user_mentor?).to be_nil
    FactoryGirl.create(:mentor, user_id: user.id)
    expect(helper.user_mentor?).not_to be_nil
  end

  it '#user_student?' do
    user = FactoryGirl.create(:user, email: '1@user.helper.spec', uid: '1.user.helper.spec')
    expect(helper.user_student?).to be_nil
    assign(:user, user)
    expect(helper.user_student?).to be_nil
    adviser_user = FactoryGirl.create(:user, email: 'user1@user.helper.spec', uid: 'uid1.user.helper.spec')
    adviser = FactoryGirl.create(:adviser, user: adviser_user)
    team = FactoryGirl.create(:team, team_name: '1.user.helper.spec', adviser: adviser)
    FactoryGirl.create(:student, user_id: user.id, team_id: team.id)
    expect(helper.user_student?).not_to be_nil
  end
end
