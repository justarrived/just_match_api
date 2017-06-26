# frozen_string_literal: true

class DocumentContentsAdderJob < ApplicationJob
  def perform(document:)
    DocumentContentsAdderService.call(document: document)
  end
end
