# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDigestSubscriberService do
  describe '::call' do
    it 'returns non-persisted, validated, DigestSubscriber if all params are blank' do
      subscriber = described_class.call(current_user: User.new)
      expect(subscriber.errors.any?).to eq(true)
    end

    context 'creates' do
      it 'returns persisted, DigestSubscriber if email is present' do
        email = "#{SecureGenerator.uuid}@example.com"
        expect do
          described_class.call(current_user: User.new, email: email)
        end.to change(DigestSubscriber, :count).by(1)
      end

      it 'returns persisted, DigestSubscriber if user is present and valid' do
        user_id = FactoryBot.create(:user).id
        expect do
          described_class.call(current_user: User.new(admin: true), user_id: user_id)
        end.to change(DigestSubscriber, :count).by(1)
      end
    end

    context 'finds' do
      it 'returns persisted, DigestSubscriber if email is present' do
        email = 'something@example.com'
        FactoryBot.create(:digest_subscriber, email: email)
        subscriber = nil

        expect do
          subscriber = described_class.call(current_user: User.new, email: email)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).to be_persisted
      end

      it 'returns persisted, DigestSubscriber if email is present and a user already has that email' do # rubocop:disable Metrics/LineLength
        user = FactoryBot.create(:user)
        FactoryBot.create(:digest_subscriber, user: user, email: nil)
        subscriber = nil

        expect do
          subscriber = described_class.call(
            current_user: User.new,
            email: user.email
          )
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).to be_persisted
      end

      it 'returns persisted, DigestSubscriber if email is present and reinstates DigestSubscriber if previously deleted' do # rubocop:disable Metrics/LineLength
        email = 'something@example.com'
        old_subscriber = FactoryBot.create(
          :digest_subscriber, email: email, deleted_at: Time.zone.now
        )
        subscriber = nil

        expect(old_subscriber.deleted_at).not_to be_nil

        expect do
          subscriber = described_class.call(current_user: User.new, email: email)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber.deleted_at).to be_nil
        expect(old_subscriber).to eq(subscriber)
      end

      it 'returns persisted, DigestSubscriber if user is present and valid' do
        user = FactoryBot.create(:user)
        subscriber = FactoryBot.create(:digest_subscriber, user: user, email: nil)
        subscriber = nil

        expect do
          subscriber = described_class.call(current_user: user, user_id: user.id)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).to be_persisted
      end

      it 'returns non-persisted, invalid, DigestSubscriber if user is present and tries to set anothers users id' do # rubocop:disable Metrics/LineLength
        user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        subscriber = FactoryBot.create(:digest_subscriber, user: other_user, email: nil)
        subscriber = nil

        expect do
          subscriber = described_class.call(current_user: user, user_id: other_user.id)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).not_to be_persisted
        expect(subscriber.errors.any?).to eq(true)
      end

      it 'returns persisted, valid, DigestSubscriber if user is present and tries to set anothers users id and user is admin' do # rubocop:disable Metrics/LineLength
        user = FactoryBot.create(:admin_user)
        other_user = FactoryBot.create(:user)
        subscriber = FactoryBot.create(:digest_subscriber, user: other_user, email: nil)
        subscriber = nil

        expect do
          subscriber = described_class.call(current_user: user, user_id: other_user.id)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).to be_persisted
        expect(subscriber.errors.any?).to eq(false)
      end

      it 'returns persisted, valid, DigestSubscriber if a logged in user tries to create a new subscriber with their user email' do # rubocop:disable Metrics/LineLength
        user = FactoryBot.create(:user)
        subscriber = FactoryBot.create(:digest_subscriber, user: user, email: nil)
        subscriber = nil

        expect do
          subscriber = described_class.call(current_user: user, email: user.email)
        end.to change(DigestSubscriber, :count).by(0)

        expect(subscriber).to be_persisted
        expect(subscriber.errors.any?).to eq(false)
        expect(subscriber.user_id.to_s).to eq(user.id.to_s)
        expect(subscriber.email).to be_nil
      end
    end
  end
end
