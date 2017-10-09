# frozen_string_literal: true

FactoryGirl.define do
  factory :guide_section_article do
    language nil
    association :section, factory: :guide_section
  end
end

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
