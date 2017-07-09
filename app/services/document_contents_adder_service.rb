# frozen_string_literal: true

require 'apache_tika_client'

class DocumentContentsAdderService
  def self.call(document:)
    return unless AppConfig.document_parser_active?

    parser = ApacheTikaClient.new
    body = parser.text_from_url(document.url, document.document_content_type)
    return if body.blank?

    document.text_content = body
    document.save!
  end
end
