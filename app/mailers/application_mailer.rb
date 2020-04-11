# mailer base
class ApplicationMailer < ActionMailer::Base
  default from: 'nusskylab@gmail.com'
  layout 'mailer'
end
