# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateJobDigestService do
  let(:valid_job_digest_params) do
    { notification_frequency: :daily }
  end

  describe '::call' do
    it 'can find job_digest subscriber using its UUID' do
      digest = nil
      subscriber = FactoryBot.create(:digest_subscriber)

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [],
          occupation_ids_param: {},
          current_user: User.new,
          uuid: subscriber.uuid
        )
      end.to change(DigestSubscriber, :count).by(0)

      expect(digest).to be_persisted
    end

    it 'sends digest created notification' do
      subscriber = FactoryBot.create(:digest_subscriber)

      allow(DigestCreatedNotifier).to receive(:call).and_return(nil)
      digest = described_class.call(
        job_digest_params: valid_job_digest_params,
        addresses_params: [],
        occupation_ids_param: {},
        current_user: User.new,
        uuid: subscriber.uuid
      )
      expect(DigestCreatedNotifier).to have_received(:call).with(job_digest: digest)
    end

    it 'can create job digest occupations' do
      digest = nil
      occupation = FactoryBot.create(:occupation)

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [],
          occupation_ids_param: [occupation.id],
          current_user: User.new,
          email: 'email@example.com'
        )
      end.to change(JobDigestOccupation, :count).by(1)

      expect(digest).to be_persisted
    end

    it 'can create job_digest subscriber using email' do
      digest = nil
      email = 'email@example.com'

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [],
          occupation_ids_param: {},
          current_user: User.new,
          email: email
        )
      end.to change(DigestSubscriber, :count).by(1)

      expect(digest).to be_persisted
    end

    it 'can find job_digest subscriber using email' do
      digest = nil
      email = 'email@example.com'
      FactoryBot.create(:digest_subscriber, email: email)

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [],
          occupation_ids_param: {},
          current_user: User.new,
          email: email
        )
      end.to change(DigestSubscriber, :count).by(0)

      expect(digest).to be_persisted
    end

    it 'creates new address if any address fields are present' do
      digest = nil

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [{ street1: 'street1' }],
          occupation_ids_param: {},
          current_user: User.new,
          email: 'email@example.com'
        )
      end.to change(Address, :count).by(1)

      expect(digest).to be_persisted
    end

    it 'creates multiple new addresses if present' do
      digest = nil

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [{ street1: 'street1' }, { city: 'Stockholm' }],
          occupation_ids_param: {},
          current_user: User.new,
          email: 'email@example.com'
        )
      end.to change(Address, :count).by(2)

      expect(digest).to be_persisted
    end

    it 'does *not* create a new address if address fields are blank' do
      digest = nil

      expect do
        digest = described_class.call(
          job_digest_params: valid_job_digest_params,
          addresses_params: [],
          occupation_ids_param: {},
          current_user: User.new,
          email: 'email@example.com'
        )
      end.to change(Address, :count).by(0)

      expect(digest).to be_persisted
    end

    it 'can create a new job digest' do
      digest = described_class.call(
        job_digest_params: valid_job_digest_params,
        addresses_params: [],
        occupation_ids_param: {},
        current_user: User.new,
        email: 'email@example.com'
      )

      expect(digest).to be_persisted
    end

    it 'can return a non-peristed, invalid job digest with errors' do
      digest = described_class.call(
        job_digest_params: {},
        addresses_params: [],
        occupation_ids_param: {},
        current_user: User.new
      )

      expect(digest).not_to be_persisted
      expect(digest.errors.any?).to eq(true)
    end
  end
end
