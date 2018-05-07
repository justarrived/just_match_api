# frozen_string_literal: true

class GuideSectionTranslation < ApplicationRecord
  belongs_to :section, class_name: 'GuideSection', foreign_key: 'guide_section_id'

  include TranslationModel
end

# == Schema Information
#
# Table name: guide_section_translations
#
#  id                :bigint(8)        not null, primary key
#  locale            :string
#  title             :string
#  slug              :string
#  short_description :string
#  guide_section_id  :bigint(8)
#  language_id       :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_guide_section_translations_on_guide_section_id  (guide_section_id)
#  index_guide_section_translations_on_language_id       (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (guide_section_id => guide_sections.id)
#  fk_rails_...  (language_id => languages.id)
#
