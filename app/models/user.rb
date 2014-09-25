class User < ActiveRecord::Base
	has_many :authorizations, dependent: :destroy
	has_many :skills, through: :expertises
	has_many :expertises
	has_many :needed_skills, through: :wants
	has_many :wants
	has_many :conversations, through: :connections
	has_many :connections
	has_many :meetings, through: :appointments
	has_many :appointments
	has_many :messages
	has_many :statuses
	has_many :comments
	has_many :likes
	attr_accessible :rate_count, :notify_messages, :notify_meetings, :message_count, :meeting_count, :education, :interests, :name, :email, :profile_pic_url, :li_token, :birthday, :star_sign, :personality, :favorite_book, :favorite_movie, :mon, :tues, :wed, :thurs, :fri, :sat, :sun, :bio, :info, :helpfulness, :location, :tagline, :follow_list

	def self.create_with_linkedin auth_hash
		profile = auth_hash['info']
		li_token = auth_hash.credentials.token
		skill_list =  auth_hash.extra.raw_info.skills.values[1].map(&:skill).map(&:name)
		user = User.new name: profile["name"], profile_pic_url: profile['image'], li_token: li_token, email: profile['email'], tagline: profile['headline'], info: profile[:description]
    user.authorizations.build :uid => auth_hash["uid"]
    user if user.save
    Skill.add skill_list, user
    user.follow_self
    user
	end

	def follow_self
		update_attributes follow_list: "#{id},"
	end

	def rating
		(helpfulness / rate_count).round
	end

	def thu
		thurs
	end

	def tue
		tues
	end

	def followed_by user
		user.follow_list.split(",").include? id.to_s
	end
	# returns a list of users based on an array of names, and array of skill names
	#first get user_ids of name matches if there's a name list
	#then get the user skill hash of there's a skill list
	#merge the two lists
	#if skills were specified, sort by number of skill matches
	# if no skills specified, search by number of looking for skill matches

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
						skills[match.id]
					else
						0
					end
				end.reverse.select {|match| skills[match.id]}
				if name_list
					p name_list
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

	def ordered_conversations
		conversations.order('updated_at desc').uniq
	end

	def following
		Status.where('user_id in (?)', follow_list.split(",")).order('created_at desc')
	end

	def upcoming_meetings
		meetings.where('start_time > (?)', Time.now).order(:start_time).select {|m| m.accepted? }
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