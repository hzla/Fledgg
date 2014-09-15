class Meeting < ActiveRecord::Base
	has_many :users, through: :appointments
	has_many :appointments

	attr_accessible :name, :title, :creator, :receiver

end