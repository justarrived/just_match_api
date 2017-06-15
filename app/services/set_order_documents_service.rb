# frozen_string_literal: true

module SetOrderDocumentsService
  def self.call(order:, order_documents_param:)
    order_documents = order_documents_param.map do |attrs_parts|
      attrs = attrs_parts.last.fetch(:document_attributes)
      next if attrs[:id]
      document = Document.new(document: attrs[:document])
      OrderDocument.new(order: order, document: document)
    end.compact
    order_documents.each(&:save!)
    order_documents
  end
end
