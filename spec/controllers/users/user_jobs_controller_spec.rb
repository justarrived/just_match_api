# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserJobsController, type: :controller do
  let(:job) { FactoryGirl.create(:job) }
  let(:user) { FactoryGirl.create(:user_with_tokens) }

  it 'assigns all job_users as @job_users' do
    job_user = FactoryGirl.create(:job_user, job: job, user: user)
    get :index, params: { auth_token: user.auth_token, user_id: user.to_param }
    expect(assigns(:job_users)).to eq([job_user])
  end

  it 'returns 401 when unauthenticated' do
    get :index, params: { user_id: user.to_param }
    expect(response.status).to eq(401)
  end
end
