require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserDocuments < BaseExporter
    def header
      %w[user_id category path file_name file_size content_type created_at updated_at]
    end

    def to_row(model)
      document = model.document

      [
        model.user_id,
        model.category,
        aws_production_url(document.document.public_url),
        document.document_file_name,
        document.document_file_size,
        document.document_content_type,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
