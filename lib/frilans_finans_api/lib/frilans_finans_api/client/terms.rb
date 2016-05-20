# frozen_string_literal: true
require 'httparty'

module FrilansFinansApi
  class Terms
    USER_URL = 'https://www.frilansfinans.se/just-arrived-employment-agreement/'.freeze
    COMPANY_USER_URL = 'https://www.frilansfinans.se/just-arrived-consultancy-agreement/'.freeze

    HEADERS = Request::HEADERS

    def self.get(type:)
      url = case type
            when :company then COMPANY_USER_URL
            when :user then USER_URL
            else
              fail(ArgumentError, "Unknown type: '#{type}'")
            end

      HTTParty.get(url, headers: headers).parsed_response
    end

    def self.headers
      # Must be dup frozen hash, since HTTParty modifies it
      HEADERS.dup
    end
  end
end
