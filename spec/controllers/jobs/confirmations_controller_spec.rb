# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::ConfirmationsController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryBot.create(:user_with_tokens) }
    let(:job) { FactoryBot.create(:job, owner: owner) }
    let(:owner) { FactoryBot.create(:company_user) }
    let(:job_user) { FactoryBot.create(:job_user_accepted, job: job, user: user) }
    let(:terms_agreement) { FactoryBot.create(:terms_agreement) }
    let(:consent) { true }
    let(:new_attributes) { {} }

    let(:params) do
      {
        auth_token: user.auth_token,
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
      post :create, params: params
      job_user.reload
      expect(job_user.will_perform).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'fills job position' do
      post :create, params: params
      expect(assigns(:job).reload.position_filled?).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'creates frilans finans invoice' do
      expect do
        post :create, params: params
      end.to change(FrilansFinansInvoice, :count).by(1)
    end

    it 'notifies user when updated Job#will_perform is set to true and sends notifications to rejected users' do # rubocop:disable Metrics/LineLength
      # Already rejected job users, should *not* receive a notification
      FactoryBot.create(:job_user, job: job_user.job, rejected: true)
      rejected_job_user = FactoryBot.create(:job_user, job: job_user.job)

      notifier_args = { job_user: job_user, owner: owner }
      allow(ApplicantWillPerformNotifier).to receive(:call).with(notifier_args)
      allow(ApplicantRejectedNotifier).to receive(:call).with(job_user: rejected_job_user)
      post :create, params: params
      expect(ApplicantWillPerformNotifier).to have_received(:call).once
      expect(ApplicantRejectedNotifier).to have_received(:call).once
    end

    it 'creates a TermsAgreementConsent' do
      expect do
        post :create, params: params
      end.to change(TermsAgreementConsent, :count).by(1)
    end

    context 'with consent false' do
      let(:consent) { false }

      it 'returns error if consent is not true' do
        post :create, params: params
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
        post :create, params: params
        expect(response.status).to eq(422)
        error_message = I18n.t('errors.job_user.terms_agreement_not_found')
        parsed_body = JSON.parse(response.body)
        error = parsed_body['errors'].first
        expect(error['status']).to eq(404)
        expect(error['detail']).to eq(error_message)
      end
    end

    context 'staffing job with missing terms agreement ID param' do
      let(:terms_agreement) { TermsAgreement.new }
      let(:company) { FactoryBot.create(:company) }
      let(:job) { FactoryBot.create(:job, staffing_company: company, owner: owner) }
      let(:params) do
        {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param,
          data: {
            attributes: {
              consent: consent
            }
          }
        }
      end

      it 'success' do
        post :create, params: params
        expect(response.status).to eq(200)
      end
    end
  end
end
