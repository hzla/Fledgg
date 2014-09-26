class MeetingNotificationWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform user_id, other_user_id, meeting_id
		user = User.find user_id
		other_user = User.find other_user_id
		meeting = Meeting.find meeting_id
		NotificationMailer.meeting_notification(user, other_user, meeting).deliver
	end
end