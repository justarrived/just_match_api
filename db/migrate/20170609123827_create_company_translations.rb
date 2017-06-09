# frozen_string_literal: true

class CreateCompanyTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :company_translations do |t|
      t.string :locale
      t.string :short_description
      t.text :description
      t.belongs_to :language, foreign_key: true
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
