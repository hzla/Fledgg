class Status < ActiveRecord::Base
	attr_accessible :body, :user_id, :comment_count, :like_count
	has_many :comments
	belongs_to :user


end