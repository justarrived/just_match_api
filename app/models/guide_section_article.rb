# frozen_string_literal: true

class GuideSectionArticle < ApplicationRecord
  belongs_to :language, optional: true
  belongs_to :guide_section
  belongs_to :next_article, optional: true, class_name: 'GuideSectionArticle', foreign_key: 'next_guide_section_article_id' # rubocop:disable Metrics/LineLength

  include Translatable
  translates :title, :slug, :short_description, :body
end

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: guide_section_articles
#
#  id                            :integer          not null, primary key
#  language_id                   :integer
#  guide_section_id              :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  next_guide_section_article_id :integer
#
# Indexes
#
#  index_guide_section_articles_on_guide_section_id               (guide_section_id)
#  index_guide_section_articles_on_language_id                    (language_id)
#  index_guide_section_articles_on_next_guide_section_article_id  (next_guide_section_article_id)
#
# Foreign Keys
#
#  fk_rails_...  (guide_section_id => guide_sections.id)
#  fk_rails_...  (language_id => languages.id)
#
