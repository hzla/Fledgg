class SkillsController < ApplicationController
	include SessionsHelper

	def create
		skill = Skill.find_or_create_by(name: params[:skill_name])
		Expertise.find_or_create_by(user_id: current_user.id, skill_id: skill.id)
		render json: skill
	end

	def destroy
		Expertise.where(user_id: current_user.id, skill_id: params[:id]).first.destroy
		render nothing: true
	end

end