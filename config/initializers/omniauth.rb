Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'
  provider :openid, :name => 'NUS', :identifier => 'https://openid.nus.edu.sg/', :store => OpenID::Store::Filesystem.new('/tmp')
end

OmniAuth.config.logger = Rails.logger
