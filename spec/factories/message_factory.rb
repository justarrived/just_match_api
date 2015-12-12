FactoryGirl.define do
  factory :message do
    body 'Message content.'
    association :author, factory: :user
    association :language
    association :chat
  end
end
