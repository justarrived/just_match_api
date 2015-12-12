FactoryGirl.define do
  factory :job do
    name 'A job'
    max_rate 500
    description 'Watman' * 2
    address 'Bankgatan 14C, Lund'
    association :owner, factory: :user
    association :language

    # job_with_skills will create job skills after the user has been created
    factory :job_with_skills do
      # skills_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        skills_count 5
      end

      # the after(:create) yields two values; the job instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create
      after(:create) do |job, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        job.skills = skills
      end
    end
  end
end
