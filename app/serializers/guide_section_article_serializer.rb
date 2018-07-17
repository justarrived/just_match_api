# frozen_string_literal: true

class GuideSectionArticleSerializer < ApplicationSerializer
  ATTRIBUTES = %i(title slug short_description body language_id).freeze

  attributes ATTRIBUTES

  link(:self) { api_v1_guides_guide_section_article_url(object.section, object) }

  belongs_to :language
  belongs_to :section

  attribute :body_html do
    to_html(object.original_body)
  end

  attribute :translated_text do
    {
      title: object.translated_title,
      slug: object.translated_slug,
      short_description: object.translated_short_description,
      body: object.translated_body,
      body_html: to_html(object.translated_body),
      language_id: object.translated_language_id
    }
  end
end

# == Schema Information
#
# Table name: guide_section_articles
#
#  id               :bigint(8)        not null, primary key
#  language_id      :bigint(8)
#  guide_section_id :bigint(8)
#  order            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_guide_section_articles_on_guide_section_id  (guide_section_id)
#  index_guide_section_articles_on_language_id       (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (guide_section_id => guide_sections.id)
#  fk_rails_...  (language_id => languages.id)
#
