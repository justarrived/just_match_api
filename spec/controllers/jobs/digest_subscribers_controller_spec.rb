# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::DigestSubscribersController, type: :controller do
  describe 'GET #show' do
    let(:subscriber) { FactoryBot.create(:digest_subscriber) }

    it 'returns 200 when found' do
      get :show, params: { digest_subscriber_id: subscriber.uuid }

      expect(response).to be_success
    end

    context 'param is user id' do
      let(:admin_user) { FactoryBot.create(:admin_user) }

      it 'returns 200 when found' do
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(admin_user))
        FactoryBot.create(:digest_subscriber, user: admin_user, email: nil)

        get :show, params: { digest_subscriber_id: admin_user.id }

        expect(response.status).to eq(200)
      end
    end

    it 'returns 404 when not found' do
      get :show, params: { digest_subscriber_id: 'buren' }

      expect(response).to be_not_found
    end
  end

  describe 'POST #create' do
    let(:job_digest) { FactoryBot.create(:job_digest) }

    context 'with valid params' do
      it 'creates a new JobDigest' do
        valid_attributes = {
          data: {
            attributes: {
              email: 'buren@example.com'
            }
          }
        }
        expect do
          post :create, params: valid_attributes
        end.to change(DigestSubscriber, :count).by(1)
      end

      it 'returns existing JobDigest if user email already exists' do
        user = FactoryBot.create(:user, email: 'digest-email@example.com')
        FactoryBot.create(:digest_subscriber, user: user, email: nil)

        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(user))

        valid_attributes = {
          data: {
            attributes: { email: user.email }
          }
        }
        expect do
          post :create, params: valid_attributes
        end.to change(DigestSubscriber, :count).by(0)

        expect(response.status).to eq(201)
      end

      it 'returns existing JobDigest if user id already exists and user is logged in' do
        user = FactoryBot.create(:user, email: 'digest-email@example.com')
        FactoryBot.create(:digest_subscriber, user: user, email: nil)
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(user))

        valid_attributes = {
          data: {
            attributes: { user_id: user.id }
          }
        }
        expect do
          post :create, params: valid_attributes
        end.to change(DigestSubscriber, :count).by(0)

        expect(response.status).to eq(201)
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
    it 'marks digest_subscriber as deleted if found by uuid' do
      subscriber = FactoryBot.create(:digest_subscriber)

      expect do
        delete :destroy, params: { digest_subscriber_id: subscriber.uuid }
      end.to change(DigestSubscriber, :count).by(0)

      subscriber.reload

      expect(subscriber.deleted_at).not_to be_nil
    end

    it 'returns 404 status when digest_subscriber_id is found by #id' do
      id = FactoryBot.create(:digest_subscriber).id
      delete :destroy, params: { digest_subscriber_id: id }
      expect(response.status).to eq(404)
    end

    it 'returns 404 status when digest_subscriber not found' do
      delete :destroy, params: { digest_subscriber_id: '-1' }
      expect(response.status).to eq(404)
    end
  end
end
