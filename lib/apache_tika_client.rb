# frozen_string_literal: true

require 'httparty'

class ApacheTikaClient
  BASE_URI = 'https://apache-tika.justarrived.se'

  def initialize(base_uri: BASE_URI)
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
