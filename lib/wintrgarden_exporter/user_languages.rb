require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  class UserLanguages < BaseExporter
    def header
      %w[user_id name proficiency created_at updated_at]
    end

    def to_row(model)
      [
        model.user_id,
        model.en_name,
        wintrgarden_proficiency(model.proficiency),
        model.created_at,
        model.updated_at
      ]
    end

    def wintrgarden_proficiency(proficiency)
      return 1 if proficiency == 1
      return 2 if proficiency == 2
      return 4 if proficiency == 5

      3
    end
  end
end
