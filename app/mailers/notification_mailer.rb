class NotificationMailer < ActionMailer::Base
  default from: "mailer@fledgg.com"

  def message_notification user, other_user
    @user = user
    @other_user = other_user
    mail(to: @user.email, subject: "You have a new message from #{other_user.name}!")
  end

  def meeting_notification user, other_user, meeting
    @meeting = meeting 
  	@user = user
    @other_user = other_user
  	mail(to: @user.email, subject: "You have a meeting request from #{other_user.name}!")
  end
end
