# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuideSectionArticle, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
