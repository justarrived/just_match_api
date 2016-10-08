# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::ConfirmationsController, type: :controller do
  context '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:job) { FactoryGirl.create(:job, owner: owner) }
    let(:owner) { FactoryGirl.create(:user) }
    let(:job_user) { FactoryGirl.create(:job_user_accepted, job: job, user: user) }

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
        job_user_id: job_user.to_param
      }.merge(new_attributes)
    end

    it 'can set #will_perform attribute' do
      post :create, params, valid_session
      job_user.reload
      expect(job_user.will_perform).to eq(true)
    end

    it 'fills job position' do
      post :create, params, valid_session
      expect(assigns(:job).position_filled?).to eq(true)
    end

    it 'creates frilans finans invoice' do
      expect do
        post :create, params, valid_session
      end.to change(FrilansFinansInvoice, :count).by(1)
    end

    it 'notifies user when updated Job#will_perform is set to true' do
      notifier_args = { job_user: job_user, owner: owner }
      allow(ApplicantWillPerformNotifier).to receive(:call).with(notifier_args)
      post :create, params, valid_session
      expect(ApplicantWillPerformNotifier).to have_received(:call)
    end
  end
end
