# frozen_string_literal: true

class RemoveDocumentService
  def self.call(ids)
    Document.where(id: ids).each(&:destroy!)
  end
end
