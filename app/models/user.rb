# User: user modeling
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  devise :recoverable, :rememberable, :trackable, :validatable
  # for Gravatar
  include Gravtastic
  gravtastic

  NUS_PROVIDER_REGEX = /\ANUS\z/
  NUS_OPEN_ID_PREFIX_REGEX = %r{\Ahttps:\/\/openid.nus.edu.sg\/}
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'

  before_validation :process_uid

  validates :email, presence: true, format: {
    with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\z/,
    message: ': Invalid email address format'
  }, uniqueness: {
    message: ': user email should be unique'
  }
  validates :user_name, presence: true
  validates :provider, presence: true
  validates :uid, uniqueness: {
    scope: :provider,
    message: ': An OpenID account can only be used for creating one account'
  }, if: 'uid.present?'
  validates :matric_number, format: {
    with: /\A$|\AA\d{7}\D\z/i,
    message: ': Invalid matric number'
  }

  has_many :registrations, dependent: :destroy

  enum provider: [:provider_nil, :provider_NUS]
  enum program_of_study: [
    :program_of_study_unknown, :program_of_study_cs, :program_of_study_ceg,
    :program_of_study_is, :program_of_study_science,
    :program_of_study_engineering, :program_of_study_fass,
    :program_of_study_business, :program_of_study_others,
    :program_of_study_infosec, :program_of_study_bza ]

  def self.from_omniauth(auth)
    user = User.find_by(provider: User.get_provider_from_raw(auth.provider),
                        uid: auth.uid)
    return user unless user.nil?
    user = User.new(email: auth.info.email, uid: auth.uid,
                    user_name: auth.info.name)
    user.clean_user_provider(auth.provider)
    user.password = Devise.friendly_token.first(8)
    user.save ? user : nil
  end

  def self.get_provider_from_raw(provider)
    if provider[NUS_PROVIDER_REGEX]
      providers[:provider_NUS]
    else
      providers[:provider_nil]
    end
  end

  def clean_user_provider(provider)
    self.provider = User.get_provider_from_raw(provider)
  end

  def process_uid
    if uid
      self.uid = uid.downcase
      self.uid = NUS_OPEN_ID_PREFIX + uid unless uid[NUS_OPEN_ID_PREFIX_REGEX]
    end
  end
end
