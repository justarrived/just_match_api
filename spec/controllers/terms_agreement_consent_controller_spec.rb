# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementConsentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user_with_tokens) }
  let(:job) { FactoryGirl.create(:job) }
  let(:terms) { FactoryGirl.create(:terms_agreement) }
  let(:valid_params) do
    {
      auth_token: user.auth_token,
      data: {
        attributes: {
          terms_agreement_id: terms.to_param,
          user_id: user.to_param,
          job_id: job.to_param
        }
      }
    }
  end

  let(:invalid_params) do
    {
      auth_token: user.auth_token,
      job_id: job.to_param,
      data: {
        attributes: {}
      }
    }
  end

  describe 'POST #create' do
    context 'valid params' do
      it 'creates a terms of agreement consent' do
        expect do
          post :create, params: valid_params
        end.to change(TermsAgreementConsent, :count).by(1)
      end
    end

    context 'invalid params' do
      it 'does not create a terms of agreement consent' do
        expect do
          post :create, params: invalid_params
        end.to change(TermsAgreementConsent, :count).by(0)
      end
    end
  end
end
