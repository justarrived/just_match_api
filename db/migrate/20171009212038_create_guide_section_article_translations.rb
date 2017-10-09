# frozen_string_literal: true

class CreateGuideSectionArticleTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_section_article_translations do |t|
      t.belongs_to :language, foreign_key: true
      t.integer :guide_section_article_id
      t.string :locale
      t.string :title
      t.string :slug
      t.string :short_description
      t.string :body

      t.timestamps
    end

    add_foreign_key(
      :guide_section_article_translations,
      'guide_section_articles',
      column: 'guide_section_article_id'
    )
  end
end
