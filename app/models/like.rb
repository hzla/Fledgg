class Like < ActiveRecord::Base
	attr_accessible :status_id, :user_id
	belongs_to :status
	belongs_to :user

end