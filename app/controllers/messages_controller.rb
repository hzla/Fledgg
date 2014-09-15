class MessagesController < ApplicationController
	include SessionsHelper

	def create
		if params[:message][:conversation_id] != ""
			Message.create(params[:message])
			render nothing: true and return
		else
			other_user = User.find params[:other_user_id]
			name1 = "#{current_user.id}-#{other_user.id}"
			name2 = "#{other_user.id}-#{current_user.id}"
			possible_conversation = current_user.conversations.where(trashed: false).where('name = ? or name = ?', name1, name2)
			if !possible_conversation.empty?
				possible_conversation.first.messages << Message.create(params[:message])
			else
				convo = Conversation.create name: "#{current_user.id}-#{other_user.id}", creator: current_user.id
				current_user.conversations << convo
				other_user.conversations << convo
				convo.messages << Message.create(params[:message])
			end
			render nothing: true
		end
	end

end