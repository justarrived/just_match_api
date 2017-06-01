# frozen_string_literal: true

class AddExtraLanguageFieldsToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :en_name, :string
    add_column :languages, :direction, :string
    add_column :languages, :local_name, :string
    add_column :languages, :system_language, :boolean, default: false
  end
end
