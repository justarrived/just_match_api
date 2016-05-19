# frozen_string_literal: true
require 'httparty'

module FrilansFinansApi
  class Terms
    USER_URL = 'https://mobil.frilansfinans.se/pdf/swe/allmana_villkor.txt'.freeze
    COMPANY_USER_URL = 'https://mobil.frilansfinans.se/pdf/swe/allmana_villkor.txt'.freeze

    HEADERS = Request::HEADERS

    def self.get(type:)
      url = case type
            when :company then COMPANY_USER_URL
            when :user then USER_URL
            else
              fail(ArgumentError, "Unknown type: '#{type}'")
            end

      HTTParty.get(url, headers: HEADERS).parsed_response
    end
  end
end
