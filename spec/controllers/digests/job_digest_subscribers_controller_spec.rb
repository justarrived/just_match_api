# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Digests::JobDigestSubscribersController, type: :controller do
  describe 'POST #create' do
    let(:job_digest) { FactoryGirl.create(:job_digest) }

    context 'with valid params' do
      it 'creates a new JobDigest' do
        valid_attributes = {
          data: {
            attributes: {
              email: 'buren@example.com',
              job_digest_id: job_digest.id
            }
          }
        }
        expect do
          post :create, params: valid_attributes
        end.to change(JobDigestSubscriber, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'returns 422 status' do
        post :create, params: {}
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys job_digest_subscriber successfully' do
      id = FactoryGirl.create(:job_digest_subscriber).id

      expect do
        delete :destroy, params: { job_digest_subscriber_id: id }
      end.to change(JobDigestSubscriber, :count).by(-1)
    end

    it 'returns 404 status when job_digest_subscriber not found' do
      delete :destroy, params: { job_digest_subscriber_id: '-1' }
      expect(response.status).to eq(404)
    end
  end
end
