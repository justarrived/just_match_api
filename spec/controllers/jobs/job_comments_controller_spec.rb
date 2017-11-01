# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobCommentsController, type: :controller do
  let(:en_language) { Language.find_or_create_by!(lang_code: :en) }
  let(:comment_body) { 'Something, something darkside..' }
  let(:user) { FactoryBot.create(:user_with_tokens) }
  let(:valid_attributes) do
    {
      auth_token: user.auth_token,
      data: {
        attributes: { language_id: en_language.to_param, body: comment_body }
      }
    }
  end

  let(:invalid_attributes) do
    {
      data: {
        attributes: { body: nil }
      }
    }
  end

  describe 'GET #index' do
    it 'assigns all comments as @comments' do
      job = FactoryBot.create(:job_with_comments, comments_count: 1)
      comment = job.comments.first
      get :index, params: { auth_token: user.auth_token, job_id: job.to_param }
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested comment as @comment' do
      job = FactoryBot.create(:job_with_comments, comments_count: 1)
      comment = job.comments.first
      params = {
        auth_token: user.auth_token,
        job_id: job.to_param,
        id: comment.to_param
      }
      get :show, params: params
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Comment' do
        job = FactoryBot.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(1)
      end

      it 'assigns a newly created comment as @comment' do
        job = FactoryBot.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        post :create, params: params
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it 'returns 201 created status' do
        job = FactoryBot.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        post :create, params: params
        expect(response.status).to eq(201)
      end

      it 'sends welcome notification' do
        allow(NewJobCommentNotifier).to receive(:call)
        job = FactoryBot.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        post :create, params: params
        expect(NewJobCommentNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved comment as @comment' do
        job = FactoryBot.create(:job)
        params = { job_id: job.to_param }.merge(invalid_attributes)
        post :create, params: params
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'does not change Comment count' do
        job = FactoryBot.create(:job)
        expect do
          params = { job_id: job.to_param }.merge(invalid_attributes)
          post :create, params: params
        end.to change(Comment, :count).by(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested comment' do
      job = FactoryBot.create(:job)
      comment = FactoryBot.create(:comment, owner: user, commentable: job)

      params = {
        auth_token: user.auth_token,
        job_id: job.to_param,
        id: comment.to_param
      }

      expect do
        delete :destroy, params: params
      end.to change(Comment, :count).by(-1)
    end

    it 'returns 204 no content status' do
      job = FactoryBot.create(:job)
      comment = FactoryBot.create(:comment, owner: user, commentable: job)
      params = {
        auth_token: user.auth_token,
        job_id: job.to_param,
        id: comment.to_param
      }
      delete :destroy, params: params
      expect(response.status).to eq(204)
    end
  end
end
