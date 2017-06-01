# frozen_string_literal: true

class AddMachineTranslationToLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :languages, :machine_translation, :boolean, default: false
  end
end
