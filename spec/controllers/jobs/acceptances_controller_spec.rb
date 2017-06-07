# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::AcceptancesController, type: :controller do
  let(:new_attributes) { {} }
  let(:user) { FactoryGirl.create(:company_user).tap(&:create_auth_token) }

  it 'notifies user when updated JobUser#accepted is set to true' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first
    params = {
      auth_token: user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    notifier_args = { job_user: job_user, owner: job.owner }
    allow(ApplicantAcceptedNotifier).to receive(:call).with(notifier_args)
    post :create, params: params
    expect(ApplicantAcceptedNotifier).to have_received(:call).with(notifier_args)
  end

  it 'sets job user accepted to true' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first

    params = {
      auth_token: user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    post :create, params: params
    expect(assigns(:job_user).accepted).to eq(true)
  end

  it 'returns 200 ok status' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first
    params = {
      auth_token: user.auth_token,
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    post :create, params: params
    expect(response.status).to eq(200)
  end
end
