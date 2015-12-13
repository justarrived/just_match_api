FactoryGirl.define do
  factory :user do
    name 'Jane Doe'
    sequence :email do |n|
      "person#{n}@example.com"
    end
    phone '1234567890'
    description 'Watman ' * 2
    address 'Bankgatan 14C, Lund'
    association :language

    # user_with_skills will create user skills after the user has been created
    factory :user_with_skills do
      # skills_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        skills_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create
      after(:create) do |user, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        user.skills = skills
      end
    end
  end
end
