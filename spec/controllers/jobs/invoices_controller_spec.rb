# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::InvoicesController, type: :controller do
  let(:job_user) { FactoryGirl.create(:job_user_passed_job) }
  let(:user) { job_user.user }
  let(:job) { job_user.job }
  let(:logged_in_user) { job.owner.tap(&:create_auth_token) }
  let(:valid_params) do
    {
      auth_token: logged_in_user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'returns 201 created' do
        post :create, params: valid_params
        expect(response.status).to eq(201)
      end

      it 'creates an Invoice' do
        expect do
          post :create, params: valid_params
        end.to change(Invoice, :count).by(1)
      end

      it 'notifies user' do
        allow(InvoiceCreatedNotifier).to receive(:call).
          with(job: job, user: user)
        post :create, params: valid_params
        expect(InvoiceCreatedNotifier).to have_received(:call)
      end

      context 'already created' do
        it 'returns 422 unprocessable entity' do
          FactoryGirl.create(:invoice, job_user: job_user)
          post :create, params: valid_params
          expect(response.status).to eq(422)
        end

        it 'does *not* notify user' do
          allow(InvoiceCreatedNotifier).to receive(:call).
            with(job: job, user: user)
          FactoryGirl.create(:invoice, job_user: job_user)
          post :create, params: valid_params
          expect(InvoiceCreatedNotifier).not_to have_received(:call)
        end
      end
    end

    context 'invalid user' do
      it 'returns 401 unauthorized' do
        params = valid_params.dup
        params.delete(:auth_token)
        post :create, params: params
        expect(response.status).to eq(401)
      end
    end
  end
end
