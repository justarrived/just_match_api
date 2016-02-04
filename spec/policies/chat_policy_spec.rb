require 'rails_helper'

RSpec.describe ChatPolicy do
  context 'admin user' do
    subject { ChatPolicy.new(admin, chat) }

    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:chat) { FactoryGirl.create(:chat) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns all chats' do
      expect(subject.scope).to eq([chat])
    end
  end

  context 'user *not* in chat' do
    subject { ChatPolicy.new(user, chat) }

    let(:user) { FactoryGirl.build(:user) }
    let(:chat) { FactoryGirl.create(:chat) }

    it 'returns true for index' do
      expect(subject.index?).to eq(false)
    end

    it 'does not return any chats in scope' do
      expect(subject.scope).to eq([])
    end
  end

  context 'user in chat' do
    subject { ChatPolicy.new(user, chat) }

    let(:user) { FactoryGirl.build(:user) }
    let(:a_user) { FactoryGirl.build(:user) }
    let(:chat) { FactoryGirl.create(:chat, users: [user, a_user]) }

    it 'returns true for index' do
      expect(subject.index?).to eq(false)
    end

    it 'does return associated chats in scope' do
      expect(subject.scope).to eq([chat])
    end
  end
end
