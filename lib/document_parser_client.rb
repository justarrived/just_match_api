# frozen_string_literal: true

require 'httparty'

class DocumentParserClient
  BASE_URI = 'https://document-parser.justarrived.se'
  HEADERS = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  }.freeze

  Result = Struct.new(:title, :text, :code)

  def initialize(auth_token: nil, base_uri: BASE_URI)
    @base_uri = base_uri
    @auth_token = auth_token
  end

  def parse(file_contents)
    encoded_file = Base64.strict_encode64(file_contents)

    response = HTTParty.post(
      url_for('/documents'),
      body: {
        auth_token: @auth_token,
        file: encoded_file
      }.to_json,
      headers: headers
    )
    data = response.parsed_response

    Result.new(data['title'], data['text'], response.code)
  end

  def url_for(path)
    "#{@base_uri}#{path}"
  end

  def headers
    HEADERS
  end
end
