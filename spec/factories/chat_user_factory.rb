# frozen_string_literal: true
FactoryGirl.define do
  factory :chat_user do
    association :chat
    association :user

    factory :chat_user_for_docs do
      id 1
      created_at Date.new(2016, 02, 10)
      updated_at Date.new(2016, 02, 12)
    end
  end
end

# == Schema Information
#
# Table name: chat_users
#
#  id         :integer          not null, primary key
#  chat_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_users_on_chat_id  (chat_id)
#  index_chat_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_3953ef352e  (user_id => users.id)
#  fk_rails_86a54ec29b  (chat_id => chats.id)
#
