# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::OwnedJobsController, type: :controller do
  let(:user) { FactoryGirl.create(:company_user) }

  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(
        receive(:current_user).
        and_return(user)
      )
    {}
  end

  it 'assigns all jobs as @jobs' do
    job = FactoryGirl.create(:job, owner: user)
    get :index, params: { user_id: user.to_param }, headers: valid_session
    expect(assigns(:jobs)).to eq([job])
  end

  it 'returns 401 for unauthorized user' do
    get :index, params: { user_id: user.to_param }
    expect(response.status).to eq(401)
  end
end
