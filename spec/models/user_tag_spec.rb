# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTag, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:tag) { FactoryBot.create(:tag) }

  describe '#safe_create' do
    it 'can create user tag' do
      expect do
        user_tag = described_class.safe_create(tag: tag, user: user)

        expect(user_tag).to be_persisted
      end.to change(described_class, :count).by(1)
    end

    it 'can safely invoke create user tag twice' do
      expect do
        user_tag = described_class.safe_create(tag: tag, user: user)
        described_class.safe_create(tag: tag, user: user)

        expect(user_tag).to be_persisted
      end.to change(described_class, :count).by(1)
    end
  end

  describe '#safe_destroy' do
    it 'can delete user tag' do
      described_class.safe_create(tag: tag, user: user)
      expect do
        described_class.safe_destroy(tag: tag, user: user)
      end.to change(described_class, :count).by(-1)
    end

    it 'can safely invoke delete user tag twice' do
      described_class.safe_create(tag: tag, user: user)
      expect do
        described_class.safe_destroy(tag: tag, user: user)
        described_class.safe_destroy(tag: tag, user: user)
      end.to change(described_class, :count).by(-1)
    end
  end
end

# == Schema Information
#
# Table name: user_tags
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_tags_on_tag_id   (tag_id)
#  index_user_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
