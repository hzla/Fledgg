class Skill < ActiveRecord::Base
	attr_accessible :name
	has_many :users, through: :expertises
	has_many :expertises

	def self.add skill_list, user
		skill_list.each do |skill|
			new_skill = find_or_create_by name: skill
			Expertise.create user_id: user.id, skill_id: new_skill.id
		end
	end

	def self.name_search skill_list
		skill_count = 0
		skill_params = {}
		skill_query = skill_list.map do |skill|
			skill_count += 1
			skill_params[(skill_count + 96).chr.to_sym] = "%#{skill}%"
			"name ilike :#{(skill_count + 96).chr}"	
		end.join(" or ")
		where(skill_query, skill_params)
	end

end