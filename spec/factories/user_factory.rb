FactoryGirl.define do
  factory :user do
    name 'Jane Doe'
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password (1..8).to_a.join
    phone '1234567890'
    description 'Watman ' * 2
    address 'Bankgatan 14C, Lund'
    association :language

    factory :user_with_skills do
      transient do
        skills_count 5
      end

      after(:create) do |user, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        user.skills = skills
      end
    end

    factory :user_with_languages do
      transient do
        languages_count 5
      end

      after(:create) do |user, evaluator|
        languages = create_list(:language, evaluator.languages_count)
        user.languages = languages
      end
    end
  end
end
