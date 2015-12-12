FactoryGirl.define do
  factory :skill do
    sequence :name do |n|
      "Skill #{n} #{SecureRandom.uuid}"
    end
    association :language
  end
end
