# frozen_string_literal: true

class AddMissingIndexToUserSystemLanguage < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key 'users', 'languages', column: 'system_language_id', name: 'users_system_language_id_fk' # rubocop:disable Metrics/LineLength
  end
end
