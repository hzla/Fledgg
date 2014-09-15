class NeededSkill < ActiveRecord::Base
	attr_accessible :name
	has_many :users, through: :expertises
	has_many :expertises

	def self.add skill_list, user
		skill_list.each do |skill|
			new_skill = find_or_create_by name: skill
			Want.create user_id: user.id, needed_skill_id: new_skill.id
		end
	end

end