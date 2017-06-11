# frozen_string_literal: true

class ChatUserSerializer < ApplicationSerializer
  belongs_to :chat
  belongs_to :user
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
#  index_chat_users_on_chat_id              (chat_id)
#  index_chat_users_on_chat_id_and_user_id  (chat_id,user_id) UNIQUE
#  index_chat_users_on_user_id              (user_id)
#  index_chat_users_on_user_id_and_chat_id  (user_id,chat_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#
