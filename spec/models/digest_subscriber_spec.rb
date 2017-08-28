# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DigestSubscriber, type: :model do
  describe '#contact_email' do
    it 'returns the email if there is no user' do
      the_email = 'some@example.com'
      subscriber = FactoryGirl.build_stubbed(:digest_subscriber, email: the_email)

      expect(subscriber.contact_email).to eq(the_email)
    end

    it 'returns the users contact email if there is a user' do
      user = FactoryGirl.build_stubbed(:user)
      subscriber = FactoryGirl.build(:digest_subscriber, email: nil, user: user)

      expect(subscriber.contact_email).to eq(user.email)
    end
  end

  describe '#validates_user_or_email_presence' do
    it 'adds error if user and email are both blank' do
      jds = described_class.new
      jds.validate

      expect(jds.errors[:user]).not_to be_empty
      expect(jds.errors[:email]).not_to be_empty
    end
  end

  describe 'validates_user_and_email_both_not_presence' do
    it 'adds error if both user AND email are present' do
      jds = described_class.new(user: FactoryGirl.build_stubbed(:user), email: 'some')
      jds.validate

      expect(jds.errors[:user]).not_to be_empty
      expect(jds.errors[:email]).not_to be_empty
    end
  end

  describe '#uuid' do
    it 'does not set if uuid is already set' do
      jds = described_class.new(uuid: 'watman')
      jds.validate

      expect(jds.uuid).to eq('watman')
    end

    it 'is present after being validated' do
      jds = described_class.new
      jds.validate

      expect(jds.uuid.length).to eq(36)
    end

    it 'is nil before being validated' do
      expect(described_class.new.uuid).to be_nil
    end
  end
end

# == Schema Information
#
# Table name: digest_subscribers
#
#  id         :integer          not null, primary key
#  email      :string
#  uuid       :string(36)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_digest_subscribers_on_user_id  (user_id)
#  index_digest_subscribers_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
