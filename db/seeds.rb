users = User.all

users.each do |user|
	status = Status.create body: Faker::Lorem.paragraph, user_id: user.id 
	comment = Comment.create body: Faker::Lorem.paragraph, user_id: users.sample.id, status_id: status.id
end