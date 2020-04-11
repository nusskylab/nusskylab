# user's related mails
class UserMailer < ApplicationMailer
  def welcome_email(user, generated_pswd = '')
    @user = user
    @pswd = generated_pswd
    mail(to: @user.email, subject: 'Welcome to Skylab')
  end

  def general_announcement(sender, receivers, subject, content)
    @sender = sender
    @content = content
    mail(
      from: @sender.email, to: @sender.email, subject: subject,
      bcc: receivers.map(&:email)
    )
  end
end
