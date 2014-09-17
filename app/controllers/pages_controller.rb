class PagesController < ApplicationController

	skip_before_action :require_login
	
	def home

	end

	def logout
		session[:user_id] = nil
		redirect_to root_path
	end

end