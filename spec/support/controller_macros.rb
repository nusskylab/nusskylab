module ControllerMacros
  def login_admin
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user, email: 'default_admin@controller.spec', uid: 'default_admin.controller.spec')
      FactoryGirl.create(:admin, user: user)
      sign_in user
    end
  end

  def login_user(user = nil)
    before(:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      user ||= FactoryGirl.create(:user, email: 'default_user@controller.spec', uid: 'default_user.controller.spec')
      sign_in user
    end
  end
end
