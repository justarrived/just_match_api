# frozen_string_literal: true

require 'uri'

class UtmUrlBuilder
  PARAMS = %w(utm_source utm_medium utm_campaign utm_term utm_content).freeze

  class << self
    attr_accessor :default_utm_source
  end

  def self.build(
    url,
    source: default_utm_source,
    medium: nil,
    campaign: nil,
    term: nil,
    content: nil
  )
    if source.nil? || source.strip.empty?
      raise(ArgumentError, "source can't be blank")
    end

    uri = URI.parse(url)
    query_parts = [['utm_source', source]]
    query_parts << ['utm_medium', medium] if medium
    query_parts << ['utm_campaign', campaign] if campaign
    query_parts << ['utm_term', term] if term
    query_parts << ['utm_content', content] if content

    new_query = URI.decode_www_form(String(uri.query)) + query_parts

    uri.query = URI.encode_www_form(new_query)
    uri.to_s
  end
end
