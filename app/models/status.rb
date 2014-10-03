class Status < ActiveRecord::Base
	attr_accessible :body, :user_id, :comment_count, :like_count
	has_many :comments, dependent: :destroy
	has_many :likes
	belongs_to :user


	def liked_by? current_user
		!likes.where(user_id: current_user).empty?
	end

	def increment_comment_count
		new_count = comment_count + 1
		update_attributes comment_count: new_count
	end

	def like_and_return_action current_user
		possible_like = Like.where(user_id: current_user.id, status_id: id)
		if possible_like.empty?
			Like.create(user_id: current_user.id, status_id: id)
			new_count = like_count + 1
			update_attributes like_count: new_count
			"liked"
		else
			possible_like.first.destroy
			new_count = like_count - 1
			update_attributes like_count: new_count
			"unliked"
		end

	end
end