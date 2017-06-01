# frozen_string_literal: true

class CreateJobUserTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :job_user_translations do |t|
      t.string :locale
      t.text :apply_message
      t.belongs_to :job_user, foreign_key: true

      t.timestamps
    end
  end
end
