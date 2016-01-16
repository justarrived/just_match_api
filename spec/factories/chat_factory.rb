FactoryGirl.define do
  factory :chat do
    # chat_with_users will create job skills after the user has been created
    factory :chat_with_users do
      # users_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        users_count 5
      end

      # the after(:create) yields two values; the chat instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create
      after(:create) do |chat, evaluator|
        users = create_list(:user, evaluator.users_count)
        chat.users = users
      end
    end

    factory :chat_with_messages do
      # messages_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        messages_count 5
      end

      # the after(:create) yields two values; the chat instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create
      after(:create) do |_chat, evaluator|
        create_list(:message, evaluator.messages_count)
      end
    end
  end
end

# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
