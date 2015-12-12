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
  end
end
