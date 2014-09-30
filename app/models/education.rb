class Education < ActiveRecord::Base
	belongs_to :user
	attr_accessible :start_year, :end_year, :user_id, :name


end