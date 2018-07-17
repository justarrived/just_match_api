# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::RatingsController do
  let(:job_user) { FactoryBot.create(:job_user_concluded, job: job) }
  let(:job_owner) { FactoryBot.create(:user_with_tokens) }
  let(:job) do
    job = FactoryBot.create(:passed_job, owner: job_owner)
    job
  end

  let(:valid_params) do
    language = FactoryBot.create(:language)
    {
      auth_token: job_owner.auth_token,
      job_id: job.to_param,
      data: {
        attributes: {
          score: 3,
          language_id: language.to_param,
          body: 'Rating comment body',
          user_id: job_user.user.to_param
        }
      }
    }
  end

  let(:invalid_params) do
    {
      auth_token: job_owner.auth_token,
      job_id: job.to_param,
      data: {
        attributes: { lang_code: nil }
      }
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Rating' do
        expect do
          post :create, params: valid_params
        end.to change(Rating, :count).by(1)
      end

      it 'creates a new Rating with comment' do
        expect do
          post :create, params: valid_params
        end.to change(Comment, :count).by(1)
      end

      it 'assigns a newly created rating as @rating' do
        post :create, params: valid_params
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating)).to be_persisted
      end

      it 'returns created status' do
        post :create, params: valid_params
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved rating as @rating' do
        post :create, params: invalid_params
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end
end
