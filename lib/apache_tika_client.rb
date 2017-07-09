# frozen_string_literal: true

require 'httparty'

class ApacheTikaClient
  class << self
    attr_accessor :base_uri
  end

  def initialize(base_uri: self.class.base_uri)
    @base_uri = base_uri
  end

  def text_from_url(document_url, content_type)
    response = HTTParty.put(
      url_for('/tika'),
      headers: {
        'Accept' => 'text/plain',
        'Content-Type' => content_type,
        'fileUrl' => document_url
      }
    )

    response.body
  end

  def url_for(path)
    "#{@base_uri}#{path}"
  end
end
