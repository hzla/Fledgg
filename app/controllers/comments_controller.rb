class CommentsController < ApplicationController
	include SessionsHelper
	include ApplicationHelper

	def create
		sanitized = sanitize params[:comment][:body]
		@comment = Comment.create(body: sanitized, status_id: params[:comment][:status_id], user_id: current_user.id)
		@comment.status.increment_comment_count
		render layout: false
	end

	def destroy
		Comment.find(params[:id]).destroy
		render nothing: true
	end
end