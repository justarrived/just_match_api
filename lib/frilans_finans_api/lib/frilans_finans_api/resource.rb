# frozen_string_literal: true

module FrilansFinansApi
  class Resource
    def initialize(document)
      @data = document || {}
    end

    def type
      @data['type']
    end

    def id
      @data['id']
    end

    def attributes
      @data['attributes']
    end

    def self_link
      @data.dig('links', 'self')
    end
  end
end
