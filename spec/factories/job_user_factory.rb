FactoryGirl.define do
  factory :job_user do
    association :user
    association :job
  end
end
