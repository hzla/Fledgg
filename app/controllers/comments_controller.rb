class CommentsController < ApplicationController
	include SessionsHelper

	def create
		p params[:comment]
		sanitized = CGI::unescapeHTML(params[:comment][:body].gsub(/<\/?[^>]*>/,"")) 
		@comment = Comment.create(body: sanitized, status_id: params[:comment][:status_id])
		current_user.comments << @comment
		status = @comment.status
		new_count = status.comment_count + 1
		status.update_attributes comment_count: new_count
		render layout: false
	end
end