class StatusesController < ApplicationController
	include SessionsHelper
	include ApplicationHelper

	def index
		@status = Status.new
		@statuses = current_user.following
		@meetings = current_user.upcoming_meetings
		@comment = Comment.new
	end

	def create
		sanitized = sanitize params[:status][:body] 
		status = Status.create(body: sanitized, user_id: current_user.id)
		comment = Comment.new
		render partial: 'show', locals: {status: status, comment: comment}
	end

	def like
		status = Status.find(params[:id])
		action = status.like_and_return_action current_user
		if action == "liked"
			render json: {dont_like: false} and return
		else
			render json: {dont_like: true} and return
		end
	end

	def destroy
		Status.find(params[:id]).destroy
		render nothing: true
	end

end





