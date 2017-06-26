# frozen_string_literal: true

require 'document_parser_client'

class DocumentContentsAdderService
  def self.call(document:)
    return unless AppConfig.document_parser_active?

    parser = DocumentParserClient.new
    body = parser.text_from_url(document.url, document.document_content_type)
    return if body.blank?

    document.text_content = body
    document.save!
  end
end
