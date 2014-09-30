class Message < ActiveRecord::Base 
	belongs_to :user
	belongs_to :conversation, touch: true

	attr_accessible :body, :user_id, :conversation_id, :subject, :read

	def short_body
		body.length > 30 ? body[0..29] + "..." : body
	end

	def short_subject
		subject.length > 30 ? subject[0..29] + "..." : subject
	end

	def date
		created_at.strftime("%B %e")
	end

	def full_date
		created_at.strftime("%B %d at %I:%M %p")
	end

end