class ConversationsController < ApplicationController
	include SessionsHelper

	def index
		@conversations = current_user.ordered_conversations.where(trashed: false)
		@send_to = params[:send_to]
		current_user.update_attributes message_count: 0
		@meetings = params[:meetings] != nil
		@name = User.find(@send_to).name if @send_to
		@message = Message.new
	end

	def show
		@conversation = Conversation.find(params[:id])
		@counter = 0
		@counter = 1 if @conversation.trashed == true
		render layout: false
	end

	def trash
		conversation = Conversation.find(params[:id])
		if conversation.name.include?(current_user.id.to_s)
			conversation.update_attributes trashed: true
		end
		render nothing: true
	end

	def trashed
		@conversations = current_user.ordered_conversations.where(trashed: true)
	end

end