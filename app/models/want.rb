class Want < ActiveRecord::Base
	attr_accessible :user_id, :needed_skill_id
	belongs_to :user
	belongs_to :needed_skill

end