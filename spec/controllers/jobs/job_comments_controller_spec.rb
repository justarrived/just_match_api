require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobCommentsController, type: :controller do
  let(:valid_attributes) do
    language = FactoryGirl.create(:language)
    body = 'Something, something darkside..'
    {
      data: {
        attributes: { language_id: language.to_param, body: body }
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

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    {}
  end

  describe 'GET #index' do
    it 'assigns all comments as @comments' do
      job = FactoryGirl.create(:job_with_comments, comments_count: 1)
      comment = job.comments.first
      get :index, { job_id: job.to_param }, valid_session
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested comment as @comment' do
      job = FactoryGirl.create(:job_with_comments, comments_count: 1)
      comment = job.comments.first
      get :show, { job_id: job.to_param, id: comment.to_param }, valid_session
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Comment' do
        job = FactoryGirl.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        expect do
          post :create, params, valid_session
        end.to change(Comment, :count).by(1)
      end

      it 'assigns a newly created comment as @comment' do
        job = FactoryGirl.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        post :create, params, valid_session
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it 'returns 201 created status' do
        job = FactoryGirl.create(:job)
        params = { job_id: job.to_param }.merge(valid_attributes)
        post :create, params, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved comment as @comment' do
        job = FactoryGirl.create(:job)
        params = { job_id: job.to_param }.merge(invalid_attributes)
        post :create, params, valid_session
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'does not change Comment count' do
        job = FactoryGirl.create(:job)
        expect do
          params = { job_id: job.to_param }.merge(invalid_attributes)
          post :create, params, valid_session
        end.to change(Comment, :count).by(0)
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { FactoryGirl.create(:user) }

    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      {}
    end

    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            attributes: { body: 'Something, something else darkside..' }
          }
        }
      end

      it 'updates the requested comment' do
        job = FactoryGirl.create(:job)
        comment = FactoryGirl.create(:comment, owner: user, commentable: job)
        params = { job_id: job.to_param, id: comment.to_param }.merge(new_attributes)
        put :update, params, valid_session
        comment.reload
        expect(comment.body).to eq('Something, something else darkside..')
      end

      it 'assigns the requested comment as @comment' do
        job = FactoryGirl.create(:job)
        comment = FactoryGirl.create(:comment, owner: user, commentable: job)
        params = { job_id: job.to_param, id: comment.to_param }.merge(new_attributes)
        put :update, params, valid_session
        expect(assigns(:comment)).to eq(comment)
      end

      it 'returns 200 ok status' do
        job = FactoryGirl.create(:job)
        comment = FactoryGirl.create(:comment, owner: user, commentable: job)
        params = { job_id: job.to_param, id: comment.to_param }.merge(new_attributes)
        put :update, params, valid_session
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid params' do
      it 'assigns the comment as @comment' do
        job = FactoryGirl.create(:job)
        comment = FactoryGirl.create(:comment, owner: user, commentable: job)
        params = {
          job_id: job.to_param,
          id: comment.to_param,
          comment: invalid_attributes
        }
        put :update, params, valid_session
        expect(assigns(:comment)).to eq(comment)
      end

      it 'returns 422 unprocessable entity status' do
        job = FactoryGirl.create(:job)
        comment = FactoryGirl.create(:comment, owner: user, commentable: job)
        params = {
          job_id: job.to_param,
          id: comment.to_param,
          comment: invalid_attributes
        }
        put :update, params, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryGirl.create(:user) }

    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      {}
    end

    it 'destroys the requested comment' do
      job = FactoryGirl.create(:job)
      comment = FactoryGirl.create(:comment, owner: user, commentable: job)
      expect do
        delete :destroy, { job_id: job.to_param, id: comment.to_param }, valid_session
      end.to change(Comment, :count).by(-1)
    end

    it 'returns 204 no content status' do
      job = FactoryGirl.create(:job)
      comment = FactoryGirl.create(:comment, owner: user, commentable: job)
      delete :destroy, { job_id: job.to_param, id: comment.to_param }, valid_session
      expect(response.status).to eq(204)
    end
  end
end
