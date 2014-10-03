class SessionsController < ApplicationController
	skip_before_action :require_login


	def create
	  auth_hash = request.env['omniauth.auth']
	  auth = Authorization.find_by_uid auth_hash['uid']
	 	
	  #redirect to user page if they've already authorized
	  if auth
	    session[:user_id] = auth.user.id
	    redirect_to statuses_path and return
	  else #create new user if not authorized
	    user = User.create_with_linkedin auth_hash
	    session[:user_id] = user.id 
	    redirect_to onboarding_path
	  end
	end

end