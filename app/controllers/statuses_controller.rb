class StatusesController < ApplicationController
	include SessionsHelper

	def index
		@status = Status.new
		@statuses = current_user.following
		@meetings = current_user.upcoming_meetings
		@comment = Comment.new
	end

	def create
		sanitized = CGI::unescapeHTML(params[:status][:body].gsub(/<\/?[^>]*>/,"")) 
		status = Status.create(body: sanitized)
		current_user.statuses << status
		comment = Comment.new
		render partial: 'show', locals: {status: status, comment: comment}
	end

	def like
		status = Status.find(params[:id])
		possible_like = Like.where(user_id: current_user.id, status_id: status.id)
		if possible_like.empty?
			Like.create(user_id: current_user.id, status_id: params[:id])
			new_count = status.like_count + 1
			status.update_attributes like_count: new_count
		else
			possible_like.first.destroy
			new_count = status.like_count - 1
			status.update_attributes like_count: new_count
			render json: {dont_like: true} and return
		end
		render json: {dont_like: false}
	end

	def destroy
		Status.find(params[:id]).destroy
		render nothing: true
	end

	
end





