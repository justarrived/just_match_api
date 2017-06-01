# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RatingsController, type: :controller do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:job) do
    job = FactoryGirl.create(:passed_job, owner: owner)
    job_user = FactoryGirl.create(:job_user_will_perform, job: job, user: user)
    FactoryGirl.create(:invoice, job_user: job_user)
    job
  end
  let!(:rating) do
    FactoryGirl.create(:rating, to_user: user, from_user: owner, job: job, score: 3)
  end

  let(:valid_params) { { user_id: user.to_param } }
  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    {}
  end

  it 'returns user ratings' do
    get :index, params: valid_params, headers: valid_session

    expect(response.status).to eq(200)
    expect(assigns(:ratings)).to eq([rating])
  end

  it 'returns average rating in meta tag' do
    get :index, params: valid_params, headers: valid_session

    parsed_body = JSON.parse(response.body)
    average_score = parsed_body.dig('meta', 'average-score')
    expect(average_score).to eq(3)
  end
end
