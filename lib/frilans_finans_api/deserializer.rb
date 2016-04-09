# frozen_string_literal: true

require 'json/api'

module FrilansFinansApi
  module Deserializer
    def self.parse(json)
      JSON::API.parse(json)
    end

    def self.total_pages(json)
      JSON.parse(json).dig('meta', 'pagination', 'total_pages')
    end

    def self.format_array(parsed, from_attributes)
      parsed.data.map do |resource|
        attributes = { id: resource.id, meta: resource.meta }
        from_attributes.each do |attribute|
          attributes[attribute] = resource.attributes.public_send(attribute)
        end
        attributes
      end
    end
  end
end
