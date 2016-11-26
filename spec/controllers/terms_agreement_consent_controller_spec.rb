# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::TermsAgreementConsentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:job) { FactoryGirl.create(:job) }
  let(:terms) { FactoryGirl.create(:terms_agreement) }
  let(:valid_params) do
    {
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
      job_id: job.to_param,
      data: {
        attributes: {}
      }
    }
  end

  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    {}
  end

  describe 'POST #create' do
    context 'valid params' do
      it 'creates a terms of agreement consent' do
        expect do
          post :create, params: valid_params, headers: valid_session
        end.to change(TermsAgreementConsent, :count).by(1)
      end
    end

    context 'invalid params' do
      it 'does not create a terms of agreement consent' do
        expect do
          post :create, params: invalid_params, headers: valid_session
        end.to change(TermsAgreementConsent, :count).by(0)
      end
    end
  end
end
