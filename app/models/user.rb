class User < ActiveRecord::Base
	has_many :authorizations, dependent: :destroy
	has_many :skills, through: :expertises
	has_many :expertises, dependent: :destroy
	has_many :needed_skills, through: :wants
	has_many :wants, dependent: :destroy
	has_many :conversations, through: :connections
	has_many :connections
	has_many :meetings, through: :appointments
	has_many :appointments
	has_many :messages
	has_many :statuses, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :likes
	has_many :experiences, dependent: :destroy
	has_many :educations, dependent: :destroy
	after_create :create_permalink
	attr_accessible :permalink, :role, :rate_count, :notify_messages, :notify_meetings, :message_count, :meeting_count, :education, :interests, :name, :email, :profile_pic_url, :li_token, :birthday, :star_sign, :personality, :favorite_book, :favorite_movie, :mon, :tues, :wed, :thurs, :fri, :sat, :sun, :bio, :info, :helpfulness, :location, :tagline, :follow_list

	def self.create_with_linkedin auth_hash
		profile = auth_hash['info']
		extra_info = auth_hash.extra.raw_info

		li_token = auth_hash.credentials.token
		secret = auth_hash.credentials.secret
		skill_list =  extra_info.skills.values[1].map(&:skill).map(&:name)
		user = User.new name: profile["name"], profile_pic_url: profile['image'], li_token: li_token, email: profile['email'], tagline: profile['headline'], location: profile['location']
    user.authorizations.build :uid => auth_hash["uid"], token: li_token , secret: secret
    user if user.save
    Skill.add skill_list, user
    user.follow_self

    ed_list = auth_hash.extra.raw_info.educations.values[1]
		ed_list.each do |ed|
			if ed.startDate['year'] && ed.endDate['year']
				Education.create name: ed['schoolName'], start_year: ed.startDate['year'].to_i, end_year: ed.endDate['year'].to_i, user_id: user.id
			end
		end

		exp_list = auth_hash.extra.raw_info.threeCurrentPositions.values[1]
		exp_list.each do |exp|
			start_date = Date.new exp['startDate']['year'], exp['startDate']['month']
			if exp['endDate']
				end_date = Date.new exp['endDate']['year'], exp['endDate']['month']
			end
			exp = Experience.create company: exp.company['name'], is_current: exp['isCurrent'], summary: exp['summary'], title: exp['title'], start_date: start_date, user_id: user.id
			exp.update_attributes end_date: end_date if exp['endDate']
		end
    user
	end


	#################### ATTRIBUTES ACCESSORS ###########################
	
	def rating
		(helpfulness / rate_count).round
	end

	def thu
		thurs
	end

	def tue
		tues
	end

	def to_param
		permalink
	end


	########################## MEETINGS/CONVERSATIONS #########################

	def ordered_conversations
		conversations.order('updated_at desc').uniq
	end

	def upcoming_meetings
		meetings.where('start_time > (?)', Time.now).order(:start_time).select {|m| m.accepted? }
	end

	def possible_conversation other_user
		name1 = "#{id}-#{other_user.id}"
		name2 = "#{other_user.id}-#{id}"
		conversations.where(trashed: false).where('name = ? or name = ?', name1, name2)
	end

	def notify_message
		new_count = message_count + 1
		update_attributes message_count: new_count
	end

	#######################  FOLLOWING ##########################



	# need to changed the follow_list to a following table in the future that stores both user_ids

	def follow_self
		update_attributes follow_list: "#{id},"
	end

	def followed_by user
		user.follow_list.split(",").include? id.to_s
	end

	def following
		Status.where('user_id in (?)', follow_list.split(",")).order('created_at desc')
	end

	def following_users
		User.find follow_list.split(",")
	end


	def follow user
		new_list = follow_list + "#{user.id},"
	  update_attributes follow_list: new_list
	end

	def unfollow user
		new_list = follow_list.gsub("#{user.id},", "")
		update_attributes follow_list: new_list
	end


	######################## PERMALINKS #################################

	def self.update_permalinks
		all.each do |user|
			user.update_attributes permalink: (user.name.gsub(" ","").downcase + user.id.to_s)
		end
	end

	def create_permalink
		link = name.gsub(" ","").downcase + id.to_s
		update_attributes permalink: link
	end


	######################### SEARCHING ###############################
	
	
	# returns a list of users based on an array of names, and array of skill names
	#first get user_ids of name matches if there's a name list
	#then get the user skill hash if there's a skill list
	#merge the two lists
	#if skills were specified, sort by number of skill matches
	# if no skills specified, search by number of looking for skill matches
	# returns only full matches of both name and skill 


	# can probably optimize to use joins instead of rewrite in SQL
	def search name_list=nil, skill_list=nil 		
			name_matches =  name_list ? User.name_search(name_list) : []
			
			if skill_list
				skills = User.skill_search(skill_list)
				skill_matches = skills.keys
			else
				skill_matches = []
			end
			matches = User.find (name_matches + skill_matches).uniq
			if skill_list
				matches = matches.sort_by do |match|
					if skills[match.id]
						# += 1?
						skills[match.id]
					else
						0
					end
				end.reverse.select {|match| skills[match.id]}
				if name_list
					matches = matches.select do |match| 
						!(name_list.map(&:downcase) & (match.name.downcase.split)).empty?
					end
				end
				matches
			else
				other_skills = User.find(name_matches).map do |user|
					[user, user.skills.pluck(:name)]
				end
				sought_skills = needed_skills.pluck(:name)
				other_skills = other_skills.sort_by do |user_skill|
					(user_skill[1] & sought_skills).length
				end
				other_skills.map {|user_skill| user_skill[0]}.flatten.reverse
			end			
	end

	private

	def self.name_search name_list #returns a list of user_ids from an array of names
		name_count = 0
		name_params = {}
		name_query = name_list.map do |name| #generates a query
			name_count += 1
			name_params[(name_count + 96).chr.to_sym] = "%#{name}%"
			"name ilike :#{(name_count + 96).chr}"	
		end.join(" or ")
		User.where(name_query, name_params).pluck(:id)
	end

	def self.skill_search skill_list #returns a hash of user_ids, and the number of skill matches found
		skills = Skill.name_search skill_list
		users = skills.map(&:users).flatten
		users_hash = {}
		users.each do |user|
			if !users_hash[user.id]
				users_hash[user.id] = 1
			else
				users_hash[user.id] += 1
			end
		end
		users_hash
	end
end