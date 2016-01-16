# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :language do
    lang_code 'sv'

    trait :eng do
      lang_code 'en'
    end
  end
end
