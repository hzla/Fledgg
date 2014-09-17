class UsersController < ApplicationController
	include SessionsHelper


	def show
		@user = User.find params[:id]
		@meeting = Meeting.new
		@skills = @user.skills
		@needed_skills = @user.needed_skills
		if params[:id] != current_user.id.to_s
			render('show_other') and return
		else
			render 'show'
		end

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
    current_user.update_attributes(params[:user])
    render json: current_user
  end

  def result_info
  	user = User.find params[:id]
  	render partial: 'profile_right_details', locals: {user: user}
  end

  def follow
  	new_list = current_user.follow_list += "#{params[:id]},"
  	current_user.update_attributes follow_list: new_list
  	render nothing: true
  end


end