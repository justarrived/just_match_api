# frozen_string_literal: true

class GuideSectionArticle < ApplicationRecord
  belongs_to :language, optional: true
  belongs_to :section, class_name: 'GuideSection', foreign_key: 'guide_section_id'

  include Translatable
  translates :title, :slug, :short_description, :body
end

# == Schema Information
#
# Table name: guide_section_articles
#
#  id               :integer          not null, primary key
#  language_id      :integer
#  guide_section_id :integer
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
