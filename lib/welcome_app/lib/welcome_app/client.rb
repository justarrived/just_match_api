# frozen_string_literal: true

require 'httparty'

module WelcomeApp
  class Client
    def user_exist?(email:)
      result = HTTParty.get("#{base_uri}/user-exist", query: { email: email })
      result.body == 'true'
    end

    private

    def base_uri
      WelcomeApp.config.base_uri
    end
  end
end
