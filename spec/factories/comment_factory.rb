FactoryGirl.define do
  factory :comment do
    body 'Something, something darkside..'
    association :language
    association :owner, factory: :user
    association :commentable, factory: :job
  end
end
