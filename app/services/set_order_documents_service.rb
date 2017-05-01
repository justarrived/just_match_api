# frozen_string_literal: true

module SetOrderDocumentsService
  def self.call(order:, order_documents_param:)
    return OrderDocument.none if order_documents_param.nil?

    current_order_documents = order.order_documents
    order_documents_params = normalize_order_documents(order_documents_param)
    order_documents = order_documents_params.map do |attrs_parts|
      attrs = attrs_parts.last.to_h.fetch(:document_attributes)
      next if attrs[:id]
      document = Document.new(document: attrs[:document])
      OrderDocument.new(order: order, document: document)
    end.compact
    order_documents.each(&:save!)
    order_documents
  end

  def self.normalize_order_documents(order_documents_param)
    order_documents_param.map do |order|
      if order.respond_to?(:permit)
        order.permit(:id)
      else
        order
      end
    end
  end
end
