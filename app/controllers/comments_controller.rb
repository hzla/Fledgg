class CommentsController < ApplicationController
	include SessionsHelper

	def create
		@comment = Comment.create params[:comment]
		current_user.comments << @comment
		status = @comment.status
		new_count = status.comment_count + 1
		status.update_attributes comment_count: new_count
		

		render layout: false
	end
end