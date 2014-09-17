class Appointment < ActiveRecord::Base
	belongs_to :user
	belongs_to :meeting
	attr_accessible :user_id, :meeting_id, :accepted, :declined, :dismissed, :rater


end