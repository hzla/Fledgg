class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  before_action :set_device_type
  
  include SessionsHelper


private

	def require_login
	  user = current_user
	  unless user
	    redirect_to root_path and return
	  end
	end

  def set_device_type
  	request.variant = :phone if browser.mobile?
    @mobile = browser.mobile?
	end

end
