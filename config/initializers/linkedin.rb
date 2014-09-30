LinkedIn.configure do |config|
  config.token = ENV["LI_API_KEY"]
  config.secret = ENV["LI_SECRET_KEY"]
end