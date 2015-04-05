class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.user_name = auth.info.name
    end
  end

  def self.create_or_silent_failure(user_hash)
    where(provider: user_hash[:provider], uid: user_hash[:uid]).first_or_create do |user|
      user.email = user_hash[:email]
      user.uid = user_hash[:uid]
      user.provider = user_hash[:provider]
      user.user_name = user_hash[:user_name]
    end
  end
end
