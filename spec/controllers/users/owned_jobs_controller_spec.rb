# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::OwnedJobsController, type: :controller do
  let(:user) do
    FactoryBot.create(:company_user).tap(&:create_auth_token)
  end

  it 'assigns all jobs as @jobs' do
    job = FactoryBot.create(:job, owner: user)
    get :index, params: { auth_token: user.auth_token, user_id: user.to_param }
    expect(assigns(:jobs)).to eq([job])
  end

  it 'returns 401 for unauthorized user' do
    get :index, params: { user_id: user.to_param }
    expect(response.status).to eq(401)
  end
end
