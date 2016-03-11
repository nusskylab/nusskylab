# user's related mails
class UserMailer < ApplicationMailer
  def welcome_email(user, generated_pswd = '')
    @user = user
    @pswd = generated_pswd
    mail(to: @user.email, subject: 'Welcome to Skylab')
  end
end
