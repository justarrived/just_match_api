FactoryGirl.define do
  factory :chat_user do
    association :chat
    association :user
  end
end
