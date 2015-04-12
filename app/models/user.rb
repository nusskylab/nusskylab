class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.user_name = auth.info.name
    end
  end

  def self.create_or_update_by_provider_and_uid(user_hash)
    user = User.find_by(provider: user_hash[:provider], uid: user_hash[:uid]) || User.new
    user_hash.each_pair do |key, value|
      if user.has_attribute?(key) and (not value.blank?)
        user[key] = value
      end
    end
    user.save
    return user
  end
end
