# frozen_string_literal: true

require 'json'

module FrilansFinansApi
  class Document
    attr_reader :status, :json, :uri

    def initialize(response)
      @json = JSON.parse(response.body)
      @status = response.code
      @uri = response.request.uri.to_s
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
      data = json['data']
      return false if data.nil? || data.is_a?(Hash)

      true
    end

    def data
      json['data']
    end

    def next_page_link
      json.dig('links', 'next')
    end

    def current_page
      json.dig('meta', 'pagination', 'page', 'number')
    end

    def per_page
      json.dig('meta', 'pagination', 'page', 'size')
    end

    def total_pages
      json.dig('meta', 'pagination', 'pages')
    end

    def total
      json.dig('meta', 'pagination', 'items')
    end

    def count
      json.dig('meta', 'pagination', 'items')
    end

    def error_status?
      # Consider both 300, 400 and 500-statuses as errors
      status >= 300
    end
  end
end
