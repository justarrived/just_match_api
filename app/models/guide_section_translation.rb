# frozen_string_literal: true

class GuideSectionTranslation < ApplicationRecord
  belongs_to :guide_section

  include TranslationModel
end

# == Schema Information
#
# Table name: guide_section_translations
#
#  id                :integer          not null, primary key
#  locale            :string
#  title             :string
#  slug              :string
#  short_description :string
#  guide_section_id  :integer
#  language_id       :integer
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
