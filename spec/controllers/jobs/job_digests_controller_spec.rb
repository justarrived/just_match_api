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
      let(:job_digest) do
        address = FactoryGirl.create(:address, city: 'a city')
        FactoryGirl.create(:job_digest, address: address, subscriber: subscriber)
      end
      let(:new_city) { 'new city' }
      let(:valid_attributes) do
        {
          job_digest_id: job_digest.id,
          data: {
            attributes: {
              city: new_city,
              digest_subscriber_uuid: subscriber.uuid
            }
          }
        }
      end
      let(:new_occupation) { FactoryGirl.create(:occupation) }
      let(:valid_attributes_with_occupations) do
        {
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
        expect(job_digest.address.city).to eq(new_city)
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
          job_digest_id: FactoryGirl.create(:job_digest, subscriber: subscriber).id,
          data: {
            attributes: { digest_subscriber_uuid: subscriber.uuid }
          }
        }
        patch :update, params: params
        expect(response.status).to eq(200)
      end
    end

    it 'it returns 404 if passed invalid {UUID,ID} combo status' do
      params = {
        job_digest_id: FactoryGirl.create(:job_digest).id,
        digest_subscriber_uuid: subscriber.uuid
      }
      patch :update, params: params
      expect(response).to be_not_found
    end
  end

  describe 'DELETE #destroy' do
    let(:subscriber) { FactoryGirl.create(:digest_subscriber) }
    let!(:valid_params) do
      {
        job_digest_id: FactoryGirl.create(:job_digest, subscriber: subscriber),
        data: {
          attributes: { digest_subscriber_uuid: subscriber.uuid }
        }
      }
    end

    it 'destroys digest_subscriber successfully if found by uuid and returns 204' do
      expect do
        delete :destroy, params: valid_params
      end.to change(JobDigest, :count).by(-1)

      expect(response.status).to eq(204)
    end

    it 'returns 404 status when digest subscriber is not found' do
      params = {
        job_digest_id: FactoryGirl.create(:job_digest),
        data: {
          attributes: { digest_subscriber_uuid: subscriber.uuid }
        }
      }
      delete :destroy, params: params
      expect(response.status).to eq(404)
    end

    it 'returns 404 status when job_digest but digest subscriber is not found' do
      params = {
        job_digest_id: FactoryGirl.create(:job_digest),
        data: {
          attributes: { digest_subscriber_uuid: subscriber.uuid }
        }
      }
      delete :destroy, params: params
      expect(response.status).to eq(404)
    end
  end
end
