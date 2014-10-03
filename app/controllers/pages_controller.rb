class PagesController < ApplicationController
	include SessionsHelper
	skip_before_action :require_login
	
	def home
		redirect_to statuses_path if current_user
	end

	def logout
		session[:user_id] = nil
		redirect_to root_path
	end

	def terms
	end

	def feedback
		NotificationMailer.feedback(params[:title],params[:email],params[:body]).deliver
		render nothing: true
	end

end