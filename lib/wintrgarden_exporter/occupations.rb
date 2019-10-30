require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class Occupations < BaseExporter
    def header
      %w[occupation_id en_name sv_name parent_id created_at updated_at]
    end

    def to_row(model)
      [
        model.id,
        model.translated_name(locale: :en),
        model.translated_name(locale: :sv),
        model.ancestry,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
