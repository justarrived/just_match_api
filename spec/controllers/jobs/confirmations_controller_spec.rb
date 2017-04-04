# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::ConfirmationsController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:job) { FactoryGirl.create(:job, owner: owner) }
    let(:owner) { FactoryGirl.create(:company_user) }
    let(:job_user) { FactoryGirl.create(:job_user_accepted, job: job, user: user) }
    let(:terms_agreement) { FactoryGirl.create(:terms_agreement) }
    let(:consent) { true }

    # Set the job_user as the logged in user
    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      { token: user.auth_token }
    end

    let(:new_attributes) { {} }

    let(:params) do
      {
        job_id: job.to_param,
        job_user_id: job_user.to_param,
        data: {
          attributes: {
            terms_agreement_id: terms_agreement.id,
            consent: consent
          }
        }
      }.merge(new_attributes)
    end

    it 'can set #will_perform attribute' do
      post :create, params: params, headers: valid_session
      job_user.reload
      expect(job_user.will_perform).to eq(true)
    end

    it 'fills job position' do
      post :create, params: params, headers: valid_session
      expect(assigns(:job).reload.position_filled?).to eq(true)
    end

    it 'creates frilans finans invoice' do
      expect do
        post :create, params: params, headers: valid_session
      end.to change(FrilansFinansInvoice, :count).by(1)
    end

    it 'notifies user when updated Job#will_perform is set to true' do
      notifier_args = { job_user: job_user, owner: owner }
      allow(ApplicantWillPerformNotifier).to receive(:call).with(notifier_args)
      post :create, params: params, headers: valid_session
      expect(ApplicantWillPerformNotifier).to have_received(:call)
    end

    it 'creates a TermsAgreementConsent' do
      expect do
        post :create, params: params, headers: valid_session
      end.to change(TermsAgreementConsent, :count).by(1)
    end

    context 'with consent false' do
      let(:consent) { false }

      it 'returns error if consent is not true' do
        post :create, params: params, headers: valid_session
        expect(response.status).to eq(422)
        error_message = I18n.t('errors.job_user.terms_agreement_consent_required')
        parsed_body = JSON.parse(response.body)
        error = parsed_body['errors'].first
        expect(error['status']).to eq(422)
        expect(error['detail']).to eq(error_message)
      end
    end

    context 'with unknown terms agreement ID' do
      let(:terms_agreement) { TermsAgreement.new }

      it 'returns error if consent is not true' do
        post :create, params: params, headers: valid_session
        expect(response.status).to eq(422)
        error_message = I18n.t('errors.job_user.terms_agreement_not_found')
        parsed_body = JSON.parse(response.body)
        error = parsed_body['errors'].first
        expect(error['status']).to eq(404)
        expect(error['detail']).to eq(error_message)
      end
    end
  end
end
