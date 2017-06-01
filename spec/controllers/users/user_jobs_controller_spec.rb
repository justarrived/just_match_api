# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserJobsController, type: :controller do
  let(:job) { FactoryGirl.create(:job) }
  let(:user) { FactoryGirl.create(:user) }

  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(
        receive(:current_user).
        and_return(user)
      )
    {}
  end

  it 'assigns all job_users as @job_users' do
    job_user = FactoryGirl.create(:job_user, job: job, user: user)
    get :index, params: { user_id: user.to_param }, headers: valid_session
    expect(assigns(:job_users)).to eq([job_user])
  end

  it 'returns 401 for unauthorized user' do
    get :index, params: { user_id: user.to_param }
    expect(response.status).to eq(401)
  end
end
