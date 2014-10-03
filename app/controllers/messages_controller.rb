class MessagesController < ApplicationController
	include SessionsHelper
	include ApplicationHelper

	def create
		sanitized = sanitize params[:message][:body]
		message = Message.create(body: sanitized, user_id: params[:message][:user_id])
		# if there is a conversation specified assign the convo
		other_user = User.find params[:other_user_id]
		other_user.notify_message
		if params[:message][:conversation_id] != ""
			message.update_attributes conversation_id: params[:message][:conversation_id]
			render nothing: true and return
		else #check for an existing conversation between the two users 
			possible_conversation = current_user.possible_conversation other_user
			if !possible_conversation.empty?
				possible_conversation.first.messages << message
			else
				convo = Conversation.create name: "#{current_user.id}-#{other_user.id}", creator: current_user.id
				current_user.conversations << convo
				other_user.conversations << convo
				convo.messages << message
			end
		end
		render nothing: true
	end

end