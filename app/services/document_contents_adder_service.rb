# frozen_string_literal: true

require 'url_document_to_text'

class DocumentContentsAdderService
  def self.call(document:)
    return unless AppConfig.document_parser_active?

    text = UrlDocumentToText.call(document.url)
    return if text.blank?

    document.text_content = text
    document.save!
  end
end
