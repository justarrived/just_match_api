# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobDigestsController, type: :controller do
  describe 'GET #index' do
    let(:subscriber) do
      FactoryGirl.create(:digest_subscriber).tap do |subscriber|
        subscriber.job_digests = [FactoryGirl.create(:job_digest)]
      end
    end

    it 'returns all digests' do
      get :index, params: { digest_subscriber_id: subscriber.uuid }

      json = JSON.parse(response.body)
      expect(json.fetch('data').first.fetch('type')).to eq('job_digests')
    end

    it 'returns empty digests if passed a user id without subscribers' do
      user = FactoryGirl.create(:user)

      get :index, params: { digest_subscriber_id: user.to_param }

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.fetch('data')).to be_empty
    end

    it 'returns 200 if passed an invalid UUID' do
      get :index, params: { digest_subscriber_id: SecureGenerator.uuid }

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.fetch('data')).to be_empty
    end
  end

  describe 'POST #create' do
    let(:occupation) { FactoryGirl.create(:occupation) }
    let(:subscriber) { FactoryGirl.create(:digest_subscriber) }
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily',
            digest_subscriber_uuid: subscriber.uuid
          }
        }
      }
    end

    let(:valid_attributes_with_occupations) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily',
            digest_subscriber_uuid: subscriber.uuid,
            occupation_ids: [{ id: occupation.id }]
          }
        }
      }
    end

    context 'with valid params' do
      it 'creates a new JobDigest' do
        expect do
          post :create, params: valid_attributes
        end.to change(JobDigest, :count).by(1)
      end

      it 'can create a new JobDigest and a new DigestSubscriber' do
        params = {
          data: {
            attributes: {
              notification_frequency: 'daily',
              email: 'job-dig-subscriber@example.com'
            }
          }
        }

        expect do
          post :create, params: params
        end.to change(DigestSubscriber, :count).by(1)
      end

      it 'can attach a new job digest to an existing user (with same email)' do
        user = FactoryGirl.create(:user)
        params = {
          data: {
            attributes: {
              notification_frequency: 'daily',
              email: user.email
            }
          }
        }

        FactoryGirl.create(:digest_subscriber, user: user, email: nil)

        expect do
          expect do
            post :create, params: params
          end.to change(JobDigest, :count).by(1)
        end.to change(DigestSubscriber, :count).by(0)

        expect(response.status).to eq(201)
      end

      it 'creates a new JobDigestOccupation' do
        expect do
          post :create, params: valid_attributes_with_occupations
        end.to change(JobDigestOccupation, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'returns 422 status' do
        post :create, params: {}
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH #update' do
    let(:occupation) { FactoryGirl.create(:occupation) }
    let(:subscriber) { FactoryGirl.create(:digest_subscriber) }
    let(:valid_attributes) do
      {
        digest_subscriber_id: subscriber.uuid,
        data: {
          attributes: {
            notification_frequency: 'daily'
          }
        }
      }
    end

    let(:valid_attributes_with_occupations) do
      {
        digest_subscriber_id: subscriber.uuid,
        data: {
          attributes: {
            notification_frequency: 'daily',
            digest_subscriber_uuid: subscriber.uuid,
            occupation_ids: [{ id: occupation.id }]
          }
        }
      }
    end

    context 'with valid params' do
      let(:job_digest) do
        address = FactoryGirl.create(:address, city: 'a city')
        FactoryGirl.create(:job_digest, addresses: [address], subscriber: subscriber)
      end
      let(:new_city) { 'new city' }
      let(:valid_attributes) do
        {
          digest_subscriber_id: subscriber.uuid,
          job_digest_id: job_digest.id,
          data: {
            attributes: {
              addresses: [{
                city: new_city
              }]
            }
          }
        }
      end
      let(:new_occupation) { FactoryGirl.create(:occupation) }
      let(:valid_attributes_with_occupations) do
        {
          digest_subscriber_id: subscriber.uuid,
          job_digest_id: job_digest.id,
          data: {
            attributes: {
              city: new_city,
              digest_subscriber_uuid: subscriber.uuid,
              occupation_ids: [{ id: new_occupation.id }]
            }
          }
        }
      end

      it 'updates the JobDigest' do
        patch :update, params: valid_attributes

        job_digest.reload
        expect(job_digest.addresses.first.city).to eq(new_city)
      end

      it 'updates a deleted JobDigest and marks it as non-deleted' do
        job_digest.soft_destroy!
        expect(job_digest.deleted_at).not_to be_nil

        patch :update, params: valid_attributes

        job_digest.reload
        expect(job_digest.deleted_at).to be_nil
      end

      it 'updates the JobDigest => JobDigestOccupation relation' do
        job_digest.occupations = [FactoryGirl.create(:occupation)]

        patch :update, params: valid_attributes_with_occupations
        job_digest.reload
        expect(job_digest.occupations.first).to eq(new_occupation)
      end
    end

    context 'with only subscriber uuid' do
      it 'it returns 200 status' do
        params = {
          digest_subscriber_id: subscriber.uuid,
          job_digest_id: FactoryGirl.create(:job_digest, subscriber: subscriber).id
        }
        patch :update, params: params
        expect(response.status).to eq(200)
      end
    end

    it 'it returns 404 if passed invalid {UUID,ID} combo status' do
      params = {
        digest_subscriber_id: subscriber.uuid,
        job_digest_id: FactoryGirl.create(:job_digest).id
      }
      patch :update, params: params
      expect(response).to be_not_found
    end
  end

  describe 'DELETE #destroy' do
    let(:subscriber) { FactoryGirl.create(:digest_subscriber) }
    let(:job_digest) { FactoryGirl.create(:job_digest, subscriber: subscriber) }
    let!(:valid_params) do
      {
        digest_subscriber_id: subscriber.uuid,
        job_digest_id: job_digest.id
      }
    end

    it 'destroys digest_subscriber by setting #deleted_at successfully if found by uuid and returns 204' do # rubocop:disable Metrics/LineLength
      expect(job_digest.deleted_at).to be_nil

      delete :destroy, params: valid_params

      job_digest.reload

      expect(job_digest.deleted_at).not_to be_nil
      expect(response.status).to eq(204)
    end

    it 'returns 404 status when digest subscriber is not found' do
      params = {
        digest_subscriber_id: subscriber.uuid,
        job_digest_id: FactoryGirl.create(:job_digest)
      }
      delete :destroy, params: params
      expect(response.status).to eq(404)
    end

    it 'returns 404 status when job_digest but digest subscriber is not found' do
      params = {
        digest_subscriber_id: subscriber.uuid,
        job_digest_id: FactoryGirl.create(:job_digest)
      }
      delete :destroy, params: params
      expect(response.status).to eq(404)
    end
  end

  describe 'GET #notification_frequencies' do
    it 'returns all digests' do
      get :notification_frequencies

      json = JSON.parse(response.body)
      first_freq = json.fetch('data').first

      daily_name = I18n.t('job_digest.notification_frequencies.daily.name')
      daily_desc = I18n.t('job_digest.notification_frequencies.daily.description')

      expect(first_freq.fetch('type')).to eq('job_digest_notification_frequencies')
      expect(first_freq.dig('attributes', 'key')).to eq('daily')

      expect(first_freq.dig('attributes', 'name')).to eq(daily_name)
      expect(first_freq.dig('attributes', 'translated_text', 'name')).to eq(daily_name)

      expect(first_freq.dig('attributes', 'description')).to eq(daily_desc)
      expect(first_freq.dig('attributes', 'translated_text', 'description')).to eq(daily_desc) # rubocop:disable Metrics/LineLength
    end
  end
end
