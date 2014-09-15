class Connection < ActiveRecord::Base
	belongs_to :user
	belongs_to :conversation


	attr_accessible :user_id, :meeting_id


end