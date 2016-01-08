require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobUsersController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class)
      .to(receive(:authenticate_user_token!)
      .and_return(user))
    { token: user.auth_token }
  end

  before(:each) do
    @user = User.find_by(auth_token: valid_session[:token])
  end

  describe 'GET #index' do
    it 'assigns all user users as @users' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: @user)
      user = job.users.first
      get :index, { job_id: job.to_param }, valid_session
      expect(assigns(:users)).to eq([user])
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        get :index, { job_id: job.to_param }, valid_session
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user user as @user' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: @user)
      user = job.users.first
      get :show, { job_id: job.to_param, id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns the requested user as @user' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: @user)
      user = job.users.first
      get :show, { job_id: job.to_param, id: user.to_param }, valid_session
      expect(assigns(:job)).to eq(job)
    end

    context 'not authorized' do
      it 'returns unauthorized status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        get :show, { job_id: job.to_param, id: user.to_param }, valid_session
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new JobUser' do
        user = FactoryGirl.create(:user)
        user1 = FactoryGirl.create(:user)
        job = FactoryGirl.create(:job, owner: user1)
        params = { job_id: job.to_param, user: { id: user.to_param } }
        expect do
          post :create, params, valid_session
        end.to change(JobUser, :count).by(1)
      end

      it 'assigns a newly created user_user as @job_user' do
        user = FactoryGirl.create(:user)
        user1 = FactoryGirl.create(:user)
        job = FactoryGirl.create(:job, owner: user1)
        params = { job_id: job.to_param, user: { id: user.to_param } }
        post :create, params, valid_session
        expect(assigns(:job_user)).to be_a(JobUser)
        expect(assigns(:job_user)).to be_persisted
      end

      it 'returns created status' do
        user = FactoryGirl.create(:user)
        user1 = FactoryGirl.create(:user)
        job = FactoryGirl.create(:job, owner: user1)
        params = { job_id: job.to_param, user: { id: user.to_param } }
        post :create, params, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job_user as @job_user' do
        job = FactoryGirl.create(:job, owner: @user)
        post :create, { job_id: job.to_param, user: {} }, valid_session
        expect(assigns(:job_user)).to be_a_new(JobUser)
      end

      it 'returns unprocessable entity status' do
        job = FactoryGirl.create(:job, owner: @user)
        post :create, { job_id: job.to_param, user: {} }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'not allowed' do
      it 'does not destroy the requested job_user' do
        job = FactoryGirl.create(:job_with_users)
        user = job.users.first
        params = { job_id: job.to_param, id: user.to_param }
        expect do
          delete :destroy, params, valid_session
        end.to change(JobUser, :count).by(0)
      end

      it 'returns not allowed status' do
        job = FactoryGirl.create(:job_with_users)
        user = job.users.first
        params = { job_id: job.to_param, id: user.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(401)
      end
    end

    context 'allowed' do
      it 'destroys the requested job_user' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        allow_any_instance_of(described_class)
          .to(receive(:authenticate_user_token!)
          .and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        expect do
          delete :destroy, params, session
        end.to change(JobUser, :count).by(-1)
      end

      it 'returns no content status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        allow_any_instance_of(described_class)
          .to(receive(:authenticate_user_token!)
          .and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        delete :destroy, params, session
        expect(response.status).to eq(204)
      end
    end
  end
end
