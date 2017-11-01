# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RatingsController, type: :controller do
  let(:owner) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user_with_tokens) }
  let(:job) do
    job = FactoryBot.create(:passed_job, owner: owner)
    job_user = FactoryBot.create(:job_user_will_perform, job: job, user: user)
    FactoryBot.create(:invoice, job_user: job_user)
    job
  end
  let!(:rating) do
    FactoryBot.create(:rating, to_user: user, from_user: owner, job: job, score: 3)
  end

  let(:valid_params) { { auth_token: user.auth_token, user_id: user.to_param } }

  it 'returns user ratings' do
    get :index, params: valid_params

    expect(response.status).to eq(200)
    expect(assigns(:ratings)).to eq([rating])
  end

  it 'returns average rating in meta tag' do
    get :index, params: valid_params

    parsed_body = JSON.parse(response.body)
    average_score = parsed_body.dig('meta', 'average-score')
    expect(average_score).to eq(3)
  end
end
