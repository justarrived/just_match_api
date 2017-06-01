# frozen_string_literal: true

class CreateInterestTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :interest_translations do |t|
      t.string :name
      t.string :locale
      t.belongs_to :language, foreign_key: true
      t.belongs_to :interest, foreign_key: true

      t.timestamps
    end
  end
end
