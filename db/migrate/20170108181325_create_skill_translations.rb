# frozen_string_literal: true
class CreateSkillTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_translations do |t|
      t.string :name
      t.string :locale
      t.belongs_to :language, foreign_key: true
      t.belongs_to :skill, foreign_key: true

      t.timestamps
    end
  end
end
