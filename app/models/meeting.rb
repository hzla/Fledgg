class Meeting < ActiveRecord::Base
	has_many :users, through: :appointments
	has_many :appointments, dependent: :destroy

	attr_accessible :name, :title, :creator, :receiver, :start_time, :url, :message

	def other_user user_id
		id = name.gsub(user_id.to_s, "").split("-").last.to_i
		User.find id
	end

	def accepted?
		appointments.where(accepted: nil).empty?
	end

	def pending? user
		!appointments.where(user_id: user.id, accepted: true ).empty? && !appointments.where(accepted: nil).empty? 
	end

	def status user
		return "accepted" if accepted?
		return "pending" if pending? user
		return "unaccepted"
	end

	def date
		start_time.strftime("%B %d at %I:%M %p")
	end

	def create_zoom_meeting
		Zoomus.configure do |c|
		  c.api_key = ENV['ZOOM_API_KEY']
		  c.api_secret = ENV['ZOOM_SECRET']
		end
		client = Zoomus.new	
		zoom_meeting = client.meeting_create host_id: ENV['HOST_ID'], start_time: start_time, type: 2, topic: "Fledgg Meeting", option_jbh: true
		update_attributes url: zoom_meeting["join_url"]
	end

end