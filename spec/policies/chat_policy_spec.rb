# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:chat) { FactoryBot.create(:chat) }

  context 'admin user' do
    subject { ChatPolicy.new(admin, chat) }

    let(:admin) { FactoryBot.build(:admin_user) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns all chats' do
      expect(subject.scope).to eq([chat])
    end
  end

  context 'user *not* in chat' do
    subject { ChatPolicy.new(user, chat) }

    let(:user) { FactoryBot.build(:user) }

    it 'returns true for index' do
      expect(subject.index?).to eq(false)
    end

    it 'does not return any chats in scope' do
      expect(subject.scope).to eq([])
    end
  end

  context 'user in chat' do
    subject { ChatPolicy.new(user, chat) }

    let(:language) { Language.find_or_create_by!(lang_code: 'en') }

    let(:user) { FactoryBot.build(:user, system_language: language) }
    let(:a_user) { FactoryBot.build(:user, system_language: language) }
    let(:chat_with_users) { FactoryBot.create(:chat, users: [user, a_user]) }

    it 'returns true for index' do
      expect(subject.index?).to eq(false)
    end

    it 'does return associated chats in scope' do
      expect(subject.scope).to eq([chat_with_users])
    end
  end
end
