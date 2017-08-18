# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobDigestsController, type: :controller do
  describe 'POST #create' do
    let(:occupation) { FactoryGirl.create(:occupation) }
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily'
          }
        }
      }
    end

    let(:valid_attributes_with_occupations) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily',
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
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily'
          }
        }
      }
    end

    let(:valid_attributes_with_occupations) do
      {
        data: {
          attributes: {
            notification_frequency: 'daily',
            occupation_ids: [{ id: occupation.id }]
          }
        }
      }
    end

    context 'with valid params' do
      let(:job_digest) { FactoryGirl.create(:job_digest, city: 'a city') }
      let(:new_city) { 'new city' }
      let(:valid_attributes) do
        {
          job_digest_id: job_digest.id,
          data: {
            attributes: {
              city: new_city
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
              occupation_ids: [{ id: new_occupation.id }]
            }
          }
        }
      end

      it 'updates the JobDigest' do
        patch :update, params: valid_attributes

        job_digest.reload
        expect(job_digest.city).to eq(new_city)
      end

      it 'updates the JobDigest => JobDigestOccupation relation' do
        job_digest.occupations = [FactoryGirl.create(:occupation)]

        patch :update, params: valid_attributes_with_occupations
        job_digest.reload
        expect(job_digest.occupations.first).to eq(new_occupation)
      end
    end

    context 'with empty params' do
      it 'it returns 200 status' do
        patch :update, params: { job_digest_id: FactoryGirl.create(:job_digest).id }
        expect(response.status).to eq(200)
      end
    end
  end
end
