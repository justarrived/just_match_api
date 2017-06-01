# frozen_string_literal: true

class CreateLanguageFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :language_filters do |t|
      t.belongs_to :filter, foreign_key: true
      t.integer :language_id
      t.integer :proficiency
      t.integer :proficiency_by_admin

      t.timestamps
    end
    add_index :language_filters, :language_id
  end
end
