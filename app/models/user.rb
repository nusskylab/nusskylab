class User < ActiveRecord::Base
  def from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.user_name = auth.info.name
    end
  end
end
