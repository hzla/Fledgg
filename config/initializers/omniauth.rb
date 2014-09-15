Rails.application.config.middleware.use OmniAuth::Builder do
  Dotenv.load
  provider :linkedin, ENV["LI_API_KEY"], ENV["LI_SECRET_KEY"], :scope => 'r_fullprofile r_emailaddress r_network rw_nus r_contactinfo', 
           :fields => ["id", "email-address", "first-name", "last-name", 
                       "headline", "industry", "picture-url", "public-profile-url", 
                       "location", "skills", "date-of-birth", "phone-numbers",        
                       "educations", "three-current-positions" ]
end