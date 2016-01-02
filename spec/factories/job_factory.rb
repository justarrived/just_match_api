FactoryGirl.define do
  factory :job do
    name 'A job'
    max_rate 500
    description 'Watman' * 2
    address 'Bankgatan 14C, Lund'
    association :owner, factory: :user
    association :language
    job_date 1.week.ago

    factory :job_with_skills do
      transient do
        skills_count 5
      end

      after(:create) do |job, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        job.skills = skills
      end
    end

    factory :job_with_users do
      transient do
        users_count 5
      end

      after(:create) do |job, evaluator|
        users = create_list(:user, evaluator.users_count)
        job.users = users
      end
    end
  end
end
