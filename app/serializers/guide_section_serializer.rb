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

# == Schema Information
#
# Table name: guide_sections
#
#  id          :bigint(8)        not null, primary key
#  order       :integer
#  language_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_guide_sections_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
