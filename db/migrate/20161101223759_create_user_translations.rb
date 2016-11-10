# frozen_string_literal: true
class CreateUserTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_translations do |t|
      t.string :locale
      t.text :description
      t.text :job_experience
      t.text :education
      t.text :competence_text
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
