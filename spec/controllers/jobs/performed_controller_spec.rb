# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::PerformedController, type: :controller do
  # Set the job_user as the logged in user
  let(:valid_session) do
    { token: user.auth_token }
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:job) { FactoryGirl.create(:passed_job, owner: owner) }
  let(:owner) { FactoryGirl.create(:user) }
  let(:job_user) { FactoryGirl.create(:job_user_will_perform, job: job, user: user) }

  it 'updates the requested job user' do
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))

    params = {
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }

    expect(job_user.performed).to eq(false)
    post :create, params: params, headers: valid_session
    job_user.reload
    expect(job_user.performed).to eq(true)
  end

  it 'nil notifies owner when updated #performed is set to true' do
    job = FactoryGirl.create(:passed_job, owner: user)
    job_user = FactoryGirl.create(:job_user_will_perform, job: job)
    user = job_user.user
    params = {
      job_id: job.to_param, job_user_id: job_user.to_param
    }

    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))

    notifier_args = { job_user: job_user, owner: job.owner }
    allow(NilNotifier).to receive(:call).with(notifier_args)
    post :create, params: params, headers: valid_session
    expect(NilNotifier).to have_received(:call)
  end
end
