FactoryGirl.define do
  factory :language do
    lang_code 'sv'

    trait :eng do
      lang_code 'en'
    end
  end
end
