class Experience < ActiveRecord::Base
	belongs_to :user
	attr_accessible :title, :company, :summary, :user_id, :start_date, :end_date, :is_current


end