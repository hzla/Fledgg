Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, "consumer_key", "consumer_secret"
end