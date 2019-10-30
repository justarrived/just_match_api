require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserImages < BaseExporter
    def header
      %w[user_id category path file_name file_size content_type created_at updated_at]
    end

    def to_row(model)
      [
        model.user_id,
        model.category,
        aws_production_url(model.image.public_url(:large) || model.image.public_url),
        model.image_file_name,
        model.image_file_size,
        model.image_content_type,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
