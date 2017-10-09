# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuideSectionArticleTranslation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: guide_section_article_translations
#
#  id                       :integer          not null, primary key
#  language_id              :integer
#  guide_section_article_id :integer
#  title                    :string
#  slug                     :string
#  short_description        :string
#  body                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_guide_s_art_transls_on_guide_s_art_id              (guide_section_article_id)
#  index_guide_section_article_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
