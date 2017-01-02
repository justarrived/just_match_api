# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserTag, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:tag) { FactoryGirl.create(:tag) }

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
#  fk_rails_7156651ad8  (tag_id => tags.id)
#  fk_rails_ea0382482a  (user_id => users.id)
#
