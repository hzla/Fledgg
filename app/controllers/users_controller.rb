class UsersController < ApplicationController
	include SessionsHelper


	def show
		@user = User.find params[:id]
		@skills = @user.skills
		@needed_skills = @user.needed_skills
		if params[:id] != current_user.id.to_s
			render('show_other') and return
		else
			render 'show'
		end

	end

	def search
		names = params[:name_search].gsub(",", "").split(" ")
		names = nil if params[:name_search] == ""
		skills = params[:skill_search].gsub(",", "").split(" ")
		skills = nil if params[:skill_search] == ""
		@searched_terms = "'#{names.join(" ") if names}  #{skills.join(" ") if skills}'" 
		@users = current_user.search names, skills
	end

	def update
    current_user.update_attributes(params[:user])
    render json: current_user
  end

  def result_info
  	user = User.find params[:id]
  	render partial: 'profile_right_details', locals: {user: user}
  end


end