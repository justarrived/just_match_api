# frozen_string_literal: true

class CreateIndustryTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :industry_translations do |t|
      t.string :name
      t.belongs_to :industry, foreign_key: true
      t.belongs_to :language, foreign_key: true
      t.string :locale

      t.timestamps
    end
  end
end
