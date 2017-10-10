# frozen_string_literal: true

class GuideSectionSerializer < ApplicationSerializer
  ATTRIBUTES = %i(title slug short_description language_id).freeze

  attributes ATTRIBUTES

  link(:self) { api_v1_guides_guide_section_url(object) }

  belongs_to :language

  has_many :articles

  attribute :translated_text do
    {
      title: object.translated_title,
      slug: object.translated_slug,
      short_description: object.translated_short_description,
      language_id: object.translated_language_id
    }
  end
end
