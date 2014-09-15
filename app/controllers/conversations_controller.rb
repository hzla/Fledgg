class ConversationsController < ApplicationController
	include SessionsHelper

	def index
		@conversations = current_user.conversations.where(trashed: false)
	end

	def show
		@conversation = Conversation.find(params[:id])
		@counter = 0
		render layout: false
	end

end