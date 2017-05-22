# frozen_string_literal: true

WelcomeApp.configure do |config|
  config.base_uri = 'https://api.welcomeapp.se'
  config.client_key = AppSecrets.welcome_app_client_key
end
