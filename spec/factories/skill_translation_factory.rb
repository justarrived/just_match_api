# frozen_string_literal: true

FactoryBot.define do
  factory :skill_translation do
    name 'MyString'
    locale 'MyString'
    association :language
    association :skill
  end
end

# == Schema Information
#
# Table name: skill_translations
#
#  id          :integer          not null, primary key
#  name        :string
#  locale      :string
#  language_id :integer
#  skill_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_skill_translations_on_language_id  (language_id)
#  index_skill_translations_on_skill_id     (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (skill_id => skills.id)
#
