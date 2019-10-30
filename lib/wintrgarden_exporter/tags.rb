require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class Tags < BaseExporter
    def header
      %w[tag_id name created_at updated_at]
    end

    def to_row(model)
      [
        model.id,
        model.name,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
