# frozen_string_literal: true

require 'httparty'

module WelcomeApp
  class Client
    def user_exists?(email:)
      result = HTTParty.get("#{base_uri}/user-exist", query: { email: email })
      result == 'true'
    end

    private

    def base_uri
      WelcomeApp.config.base_uri
    end
  end
end
