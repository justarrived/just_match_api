# frozen_string_literal: true

class CreateGuideSectionArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_section_articles do |t|
      t.belongs_to :language, foreign_key: true
      t.belongs_to :guide_section, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
