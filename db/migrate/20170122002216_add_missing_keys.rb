# frozen_string_literal: true

class AddMissingKeys < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key 'communication_template_translations', 'communication_templates', name: 'communication_template_translations_communication_template_id_fk' # rubocop:disable Metrics/LineLength
  end
end
