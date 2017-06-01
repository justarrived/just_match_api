# frozen_string_literal: true

class InterestTranslation < ApplicationRecord
  belongs_to :interest

  include TranslationModel
end

# == Schema Information
#
# Table name: interest_translations
#
#  id          :integer          not null, primary key
#  name        :string
#  locale      :string
#  language_id :integer
#  interest_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interest_translations_on_interest_id  (interest_id)
#  index_interest_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_57afcc6492  (interest_id => interests.id)
#  fk_rails_b1bd089269  (language_id => languages.id)
#
