# frozen_string_literal: true

class CreateGuideSectionTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_section_translations do |t|
      t.string :locale
      t.string :title
      t.string :short_description
      t.belongs_to :guide_section, foreign_key: true
      t.belongs_to :language, foreign_key: true

      t.timestamps
    end
  end
end
