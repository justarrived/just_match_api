# frozen_string_literal: true

require 'json'

module FrilansFinansApi
  class Document
    def initialize(json)
      @parsed_json = JSON.parse(json)
    end

    def resources
      @resources ||= begin
        if collection?
          data.map { |resource| Resource.new(resource) }
        else
          [Resource.new(data)]
        end
      end
    end

    def resource
      @resource ||= begin
        resource_data = collection? ? data.first : data
        Resource.new(resource_data)
      end
    end

    def collection?
      data = @parsed_json['data']
      return false if data.nil? || data.is_a?(Hash)

      true
    end

    def data
      @parsed_json['data']
    end

    def next_page_link
      @parsed_json.dig('meta', 'pagination', 'links', 'next')
    end

    def current_page
      @parsed_json.dig('meta', 'pagination', 'current_page')
    end

    def per_page
      @parsed_json.dig('meta', 'pagination', 'per_page')
    end

    def total_pages
      @parsed_json.dig('meta', 'pagination', 'total_pages')
    end
  end
end
