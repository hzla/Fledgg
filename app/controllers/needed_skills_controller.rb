class NeededSkillsController < ApplicationController
	include SessionsHelper

	def create
		skill = NeededSkill.find_or_create_by(name: params[:needed_skill_name])
		Want.find_or_create_by(user_id: current_user.id, needed_skill_id: skill.id)
		render json: skill
	end

	def destroy
		Want.where(user_id: current_user.id, needed_skill_id: params[:id]).first.destroy
		render nothing: true
	end
end