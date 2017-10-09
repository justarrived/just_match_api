# frozen_string_literal: true

class CreateGuideSectionArticleTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_section_article_translations do |t|
      t.belongs_to :language, foreign_key: true
      t.integer :guide_section_article_id
      t.string :title
      t.string :slug
      t.string :short_description
      t.string :body

      t.timestamps
    end

    add_index :guide_section_article_translations, %w(guide_section_article_id), name: 'index_guide_s_art_transls_on_guide_s_art_id' # rubocop:disable Metrics/LineLength
  end
end
