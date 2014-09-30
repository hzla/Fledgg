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

  def meeting_confirmation user, other_user, meeting
    @meeting = meeting 
    @user = user
    @other_user = other_user    
    mail(to: @other_user.email, subject: "Your meeting on #{@meeting.date} with #{@user.name} has been accepted.")
  end

  def meeting_reminder user, other_user, meeting
    @meeting = meeting
    @user = user
    @other_user = other_user  
    mail(to: @user.email, subject: "You have a meeting with #{@other_user.name} in 15 minutes!")
  end

  def feedback title, email, body
    @body = body
    mail(to: 'andylee.hzl@gmail.com', 'vicky@fledgg.com', subject: "Feedback from #{email} about #{title}")
  end
end
