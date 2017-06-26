# frozen_string_literal: true

require 'open-uri'
require 'document_parser_client'

class UrlDocumentToText
  def self.call(url)
    file_contents = open(url, &:read)

    result = parser_client.parse(file_contents)
    result.text
  end

  def self.parser_client
    auth_token = AppSecrets.document_parser_auth_token
    DocumentParserClient.new(auth_token: auth_token)
  end
end
