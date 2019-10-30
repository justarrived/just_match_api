require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class Skills < BaseExporter
    def header
      %w[skill_id en_name sv_name created_at updated_at]
    end

    def to_row(model)
      [
        model.id,
        model.translated_name(locale: :en),
        model.translated_name(locale: :sv),
        model.created_at,
        model.updated_at
      ]
    end
  end
end
