# frozen_string_literal: true

class RemoveDocumentsJob < ApplicationJob
  def perform(ids:)
    RemoveDocumentService.call(ids)
  end
end
