class User < ActiveRecord::Base
  before_validation :uid.downcase

  validates :email, presence: true,
            format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\z/,
                     message: 'Invalid email address format'}
  validates :user_name, presence: true,
            format: {with: /\A[*]{5,}\z/,
                     message: 'Must be of at least of length of 5'}
  validates :provider, presence: true,
            format: {with: /\ANUS\z/, message: 'Invalid OpenID provider'}
  validates :uid, presence: true,
            uniqueness: {scope: :provider,
                         message: 'An OpenID account can only be used for creating one account'}

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
