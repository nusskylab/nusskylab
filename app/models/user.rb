class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  devise :recoverable, :rememberable, :trackable, :validatable

  NUS_OPEN_ID_PREFIX_REGEX = /\Ahttps:\/\/openid.nus.edu.sg\//
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'

  before_validation :process_uid

  validates :email, presence: true,
            format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\z/,
                     message: ': Invalid email address format'},
            uniqueness: {message: 'should be unique'}
  validates :user_name, presence: true
  validates :provider, presence: true,
            format: {with: /\ANUS\z/, message: ': Invalid OpenID provider'}
  validates :uid, presence: true,
            uniqueness: {scope: :provider,
                         message: ': An OpenID account can only be used for creating one account'}

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid) || User.new
    user.email = auth.info.email
    user.provider = auth.provider
    user.uid = auth.uid
    user.user_name = auth.info.name
    user.save
    user
  end

  def process_uid
    if self.uid
      self.uid = self.uid.downcase
      if (not self.uid[NUS_OPEN_ID_PREFIX_REGEX])
        self.uid = NUS_OPEN_ID_PREFIX + self.uid
      end
    end
  end
end
