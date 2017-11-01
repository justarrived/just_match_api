# frozen_string_literal: true

FactoryBot.define do
  factory :company_translation do
    short_description 'MyText'
    description 'MyText'
    association :company
  end
end

# == Schema Information
#
# Table name: company_translations
#
#  id                :integer          not null, primary key
#  locale            :string
#  short_description :string
#  description       :text
#  language_id       :integer
#  company_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_company_translations_on_company_id   (company_id)
#  index_company_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (language_id => languages.id)
#
