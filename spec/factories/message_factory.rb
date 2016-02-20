# frozen_string_literal: true
FactoryGirl.define do
  factory :message do
    body 'Message content.'
    association :author, factory: :user
    association :language
    association :chat

    factory :message_for_docs do
      id 1
      created_at Date.new(2016, 02, 10)
      updated_at Date.new(2016, 02, 12)
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chat_id     :integer
#  author_id   :integer
#  integer     :integer
#  language_id :integer
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_messages_on_chat_id      (chat_id)
#  index_messages_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_0f670de7ba  (chat_id => chats.id)
#  fk_rails_ab4144543f  (language_id => languages.id)
#
