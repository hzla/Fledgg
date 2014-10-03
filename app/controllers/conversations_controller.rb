class ConversationsController < ApplicationController
	include SessionsHelper

	before_filter :get_convo, only: [:show, :trash, :read]

	def index
		@conversations = current_user.ordered_conversations.where(trashed: false)
		@send_to = params[:send_to]
		current_user.update_attributes message_count: 0
		@meetings = params[:meetings] != nil
		@name = User.find(@send_to).name if @send_to
		@message = Message.new
	end

	def show
		@counter = @conversation.trashed == true ? 1 : 0
		render layout: false
	end

	def trash
		if @conversation.belongs_to? current_user
			@conversation.update_attributes trashed: true
		else
			redirect_to conversations_path and return
		end
		render nothing: true
	end

	def trashed
		@conversations = current_user.ordered_conversations.where(trashed: true)
	end

	def read
		@conversation.read_by current_user
		render nothing: true
	end

	private

	def get_convo
		@conversation = Conversation.find params[:id]
	end
end