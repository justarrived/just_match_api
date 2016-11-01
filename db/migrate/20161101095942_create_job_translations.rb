# frozen_string_literal: true
class CreateJobTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :job_translations do |t|
      t.string :locale
      t.string :short_description
      t.string :name
      t.text :description
      t.belongs_to :job, foreign_key: true

      t.timestamps
    end
  end
end
