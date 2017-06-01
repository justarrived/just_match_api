# frozen_string_literal: true

class AddSystemLanguageToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :system_language_id, :integer
    add_index :users, :system_language_id
  end
end
