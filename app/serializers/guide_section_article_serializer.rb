# frozen_string_literal: true

class GuideSectionArticleSerializer < ApplicationSerializer
  ATTRIBUTES = %i(title slug short_description body language_id).freeze

  attributes ATTRIBUTES

  # TODO: Implement!
  # link(:self) { api_v1_guide_section_article_url(object.section, object) }

  belongs_to :language
  belongs_to :section

  attribute :translated_text do
    {
      title: object.translated_title,
      slug: object.translated_slug,
      short_description: object.translated_short_description,
      body: object.translated_body,
      language_id: object.translated_language_id
    }
  end
end
