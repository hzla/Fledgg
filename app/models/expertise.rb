class Expertise < ActiveRecord::Base
	attr_accessible :user_id, :skill_id
	belongs_to :user
	belongs_to :skill

end