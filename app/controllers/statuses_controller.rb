class StatusesController < ApplicationController
	include SessionsHelper

	def index
		@status = Status.new
		@statuses = current_user.following
		@meetings = current_user.upcoming_meetings
		@comment = Comment.new
	end

	def create
		status = Status.create(params[:status])
		current_user.statuses << status
		comment = Comment.new
		render partial: 'show', locals: {status: status, comment: comment}
	end

	def like
		status = Status.find(params[:id])
		new_count = status.like_count + 1
		status.update_attributes like_count: new_count
		render nothing: true
	end





end