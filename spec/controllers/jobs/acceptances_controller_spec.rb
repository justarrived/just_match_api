# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::AcceptancesController, type: :controller do
  let(:new_attributes) { {} }

  let(:valid_session) do
    user = FactoryGirl.create(:user_with_tokens)
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    { token: user.auth_token }
  end

  let(:user) { User.find_by_auth_token(valid_session[:token]) }
  # let(:owner) { User.find_by_auth_token(valid_session[:token]) }

  it 'notifies user when updated JobUser#accepted is set to true' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first
    params = {
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    notifier_args = { job_user: job_user, owner: job.owner }
    allow(ApplicantAcceptedNotifier).to receive(:call).with(notifier_args)
    post :create, params, valid_session
    expect(ApplicantAcceptedNotifier).to have_received(:call).with(notifier_args)
  end

  it 'sets job user accepted to true' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first

    params = {
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    post :create, params, valid_session
    expect(assigns(:job_user).accepted).to eq(true)
  end

  it 'returns 200 ok status' do
    job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
    job_user = job.job_users.first
    params = {
      job_id: job.to_param,
      job_user_id: job_user.to_param
    }.merge(new_attributes)

    post :create, params, valid_session
    expect(response.status).to eq(200)
  end
end
