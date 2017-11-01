# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::PerformedController, type: :controller do
  let(:user) { FactoryBot.create(:user_with_tokens) }
  let(:job) { FactoryBot.create(:passed_job, owner: owner) }
  let(:owner) { FactoryBot.create(:user) }
  let(:job_user) { FactoryBot.create(:job_user_will_perform, job: job, user: user) }

  it 'updates the requested job user' do
    params = {
      auth_token: user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }

    expect(job_user.performed).to eq(false)
    post :create, params: params
    job_user.reload
    expect(job_user.performed).to eq(true)
  end

  it 'nil notifies owner when updated #performed is set to true' do
    job = FactoryBot.create(:passed_job, owner: user)
    job_user = FactoryBot.create(:job_user_will_perform, job: job)
    user = job_user.user
    user.create_auth_token
    params = {
      auth_token: user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }

    notifier_args = { job_user: job_user, owner: job.owner }
    allow(NilNotifier).to receive(:call).with(notifier_args)
    post :create, params: params
    expect(NilNotifier).to have_received(:call)
  end
end
