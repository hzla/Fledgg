class UsersController < ApplicationController
	include SessionsHelper

	def index
		@meeting = Meeting.new
		@users = User.all.order(:name)
		@filter_bar = true 
		@index = true 
		render 'search'
	end

	def linkedin
		@meeting = Meeting.new
		client = LinkedIn::Client.new(ENV['LI_API_KEY'], ENV['LI_SECRET_KEY'])
		auth = current_user.authorizations.first
		client.authorize_from_access auth.token, auth.secret
		con_ids = client.connections.all.map(&:id)
		auths = Authorization.where 'uid in (?)', con_ids
		if auths
			@users = auths.map(&:user)
		else
			@users = []
		end 
		@filter_bar = true  
		@linkedin = true
		render 'search'
	end

	def following
		@meeting = Meeting.new
		@users = current_user.following_users
		@filter_bar = true
		@following = true  
		render 'search'
	end
	
	def show
		@user = User.find_by_permalink(params[:id])
		@meeting = Meeting.new
		@skills = @user.skills
		@needed_skills = @user.needed_skills
		if params[:id] != current_user.permalink
			render('show_other') and return
		else
			render 'show'
		end
	end

	def onboarding_profile
		@user = current_user
		@skills = @user.skills
	end

	def onboarding_skills
		@user = current_user
		@skills = Skill.all.order(:name)
	end

	def onboarding_availability
		@user = current_user
		
	end

	def rate
		user = User.find params[:id]
		rating = params[:rating]
		new_rate_count = user.rate_count + 1
		new_rating = user.helpfulness + rating.to_i
		user.update_attributes rate_count: new_rate_count, helpfulness: new_rating
		Appointment.where(user_id: current_user.id, meeting_id: params[:meeting_id]).first.update_attributes rater: false
		render nothing: true
	end

	def update
		current_user.update_attributes params[:user]
		render nothing: true
	end

	def settings
	end

	def access
		session[:user_id] = params[:id]
		redirect_to conversations_path
	end

	def search
		@meeting = Meeting.new
		names = params[:name_search].gsub(",", "").split(" ")
		names = nil if params[:name_search] == ""
		skills = params[:skill_search].gsub(",", "").split(" ")
		skills = nil if params[:skill_search] == ""
		@searched_terms = "'#{names.join(" ") if names}  #{skills.join(" ") if skills}'" 
		@users = current_user.search(names, skills).select {|x| x.id != current_user.id}
	end

	def update
		if params[:user][:info]
			info = params[:user][:info]
			sanitized = CGI::unescapeHTML(info.gsub(/<\/?[^>]*>/,""))
			current_user.update_attributes info: sanitized
		else
    	current_user.update_attributes(params[:user])
    end
    render json: current_user
  end

  def result_info
  	user = User.find params[:id]
  	render partial: 'profile_right_details', locals: {user: user}
  end

  def follow
  	other_user = User.find params[:id]
  	other_user.followed_by(current_user) ? current_user.unfollow(params[:id]) : current_user.follow(params[:id]) 
  	render nothing: true
  end


end