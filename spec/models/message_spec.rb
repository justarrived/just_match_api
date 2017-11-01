# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#created_before?' do
    it 'returns true if created before given datetime' do
      message = FactoryBot.create(:message, created_at: 2.hours.ago)
      expect(message.created_before?(1.hour.ago)).to eq(true)
    end

    it 'returns false if created after given datetime' do
      message = FactoryBot.create(:message, created_at: 1.hour.ago)
      expect(message.created_before?(2.hours.ago)).to eq(false)
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
#  fk_rails_...           (chat_id => chats.id)
#  fk_rails_...           (language_id => languages.id)
#  messages_author_id_fk  (author_id => users.id)
#
