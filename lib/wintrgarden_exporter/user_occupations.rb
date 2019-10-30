require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserOccupations < BaseExporter
    def header
      %w[user_id parent_id en_name sv_name years_of_experience created_at updated_at]
    end

    def to_row(model)
      occupation = model.occupation

      [
        model.user_id,
        model.occupation_id,
        occupation.ancestry,
        model.occupation.translated_name(locale: :en),
        model.occupation.translated_name(locale: :sv),
        model.years_of_experience,
        model.created_at,
        model.updated_at
      ]
    end
  end
end
