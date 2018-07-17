# frozen_string_literal: true

FactoryBot.define do
  factory :interest_translation do
    name 'Some interest'
    locale 'en'
    association :interest
    association :language
  end
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
#  fk_rails_...  (interest_id => interests.id)
#  fk_rails_...  (language_id => languages.id)
#
