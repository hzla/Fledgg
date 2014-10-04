class Conversation < ActiveRecord::Base
	has_many :messages
	has_many :users, through: :connections
	has_many :connections


	attr_accessible :name, :title, :creator, :meeting_id, :trashed

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

	def read_by user
		sender = other_user(user.id)
		messages.where(user_id: sender.id).update_all read: true
	end

	def read? user
		sender = other_user(user.id)
		messages.where(user_id: sender.id, read: false).empty?
	end

	def belongs_to? user
		name.include? user.id.to_s
	end

end