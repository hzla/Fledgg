class Comment < ActiveRecord::Base
	attr_accessible :body, :user_id, :status_id
	belongs_to :user
	belongs_to :status


end