# frozen_string_literal: true

class IndustryTranslation < ApplicationRecord
  belongs_to :industry

  include TranslationModel
end

# == Schema Information
#
# Table name: industry_translations
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  industry_id :bigint(8)
#  language_id :bigint(8)
#  locale      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_industry_translations_on_industry_id  (industry_id)
#  index_industry_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (industry_id => industries.id)
#  fk_rails_...  (language_id => languages.id)
#
