require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe '#find_private_chat' do
    context 'no existing private chat' do
      it 'returns nil' do
        expect(described_class.find_private_chat([])).to eq(nil)
      end
    end

    context 'with existing private chat' do
      it 'returns nil' do
        chat = FactoryGirl.create(:chat_with_users, users_count: 2)
        result = described_class.find_private_chat(chat.users)
        expect(result).to eq(chat)
      end
    end
  end

  describe '#find_or_create_private_chat' do
    context 'no existing private chat' do
      it 'returns new chat' do
        users = [FactoryGirl.create(:user), FactoryGirl.create(:user)]
        expect(described_class.find_private_chat(users)).to eq(nil)

        chat = described_class.find_or_create_private_chat(users)
        same_chat = described_class.find_private_chat(users)
        expect(chat).to eq(same_chat)
      end
    end

    context 'with existing private chat' do
      it 'returns correct chat' do
        chat = FactoryGirl.create(:chat_with_users, users_count: 2)
        result = described_class.find_or_create_private_chat(chat.users)
        expect(result).to eq(chat)
      end
    end

    context 'invalid chat' do
      it 'adds error' do
        result = described_class.find_or_create_private_chat([]).errors[:users]
        expect(result).to eq(['must be between 2-2'])
      end

      it 'returns a new Chat instance' do
        result = described_class.find_or_create_private_chat([])
        expect(result).to be_a_new(Chat)
      end
    end
  end

  describe '#common_chat_ids' do
    context 'no users' do
      it 'returns empty array' do
        expect(described_class.common_chat_ids([])).to eq([])
      end
    end

    context 'with users' do
      it 'returns common chat ids' do
        chat = FactoryGirl.create(:chat_with_users, users_count: 2)
        result = described_class.common_chat_ids(chat.users)
        expect(result).to eq([chat.id])
      end
    end
  end

  describe '#create_message' do
    context 'valid message' do
      it 'returns created message' do
        chat = FactoryGirl.create(:chat)
        author = FactoryGirl.create(:user)
        lang = FactoryGirl.create(:language)
        body = 'My text chat message.'
        messsage = chat.create_message(author: author, body: body, language_id: lang)
        expect(messsage.valid?).to eq(true)
        expect(messsage.chat).to eq(chat)
        expect(messsage.language).to eq(lang)
        expect(messsage.author).to eq(author)
      end
    end

    context 'invalid message' do
      it 'returns message with errors' do
        chat = FactoryGirl.create(:chat)
        FactoryGirl.create(:language)
        messsage = chat.create_message(author: nil, body: nil, language_id: nil)
        expect(messsage.valid?).to eq(false)
        expect(messsage.errors[:author]).to eq(["can't be blank"])
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
