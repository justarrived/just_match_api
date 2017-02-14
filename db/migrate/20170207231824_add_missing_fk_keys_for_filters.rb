# frozen_string_literal: true
class AddMissingFkKeysForFilters < ActiveRecord::Migration
  def change
    add_foreign_key 'language_filters', 'languages', name: 'language_filters_language_id_fk' # rubocop:disable Metrics/LineLength
    add_foreign_key 'skill_filters', 'skills', name: 'skill_filters_skill_id_fk'
  end
end
