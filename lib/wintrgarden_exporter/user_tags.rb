require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserTags < BaseExporter
    def header
      %w[user_id tag_id created_at updated_at]
    end

    def to_row(model)
      [
        model.user_id,
        model.tag_id,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
