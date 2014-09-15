class Conversation < ActiveRecord::Base
	has_many :messages
	has_many :users, through: :connections
	has_many :connections


	attr_accessible :name, :title, :creator, :meeting_id

	def other_user user_id
		id = name.gsub(user_id.to_s, "").split("-").last.to_i
		User.find id
	end

	def last_message
		last = messages.last
	end

	def ordered_messages
		messages.order(:created_at).reverse
	end


end