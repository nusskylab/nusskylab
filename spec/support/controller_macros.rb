module ControllerMacros
  def login_admin
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.find_by(email: 'default_admin@controller.spec')
      user ||= FactoryGirl.create(:user, email: 'default_admin@controller.spec', uid: 'default_admin.controller.spec')
      admin = Admin.find_by(user_id: user.id)
      FactoryGirl.create(:admin, user: user) if not admin
      sign_in user
    end
  end

  def login_user(user = nil)
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      user ||= User.find_by(email: 'default_user@controller.spec')
      user ||= FactoryGirl.create(:user, email: 'default_user@controller.spec', uid: 'default_user.controller.spec')
      sign_in user
    end
  end
end
