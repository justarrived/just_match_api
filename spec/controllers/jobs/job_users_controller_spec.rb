# frozen_string_literal: true
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
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    { token: user.auth_token }
  end

  let(:user) { User.find_by(auth_token: valid_session[:token]) }

  describe 'GET #index' do
    it 'assigns all user users as @users' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
      job_user = job.job_users.first
      get :index, { job_id: job.to_param }, valid_session
      expect(assigns(:job_users)).to eq([job_user])
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
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
      user = job.users.first
      get :show, { job_id: job.to_param, id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns the requested user as @user' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
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

      it 'notifies owner when a a new JobUser is created' do
        user = FactoryGirl.create(:user)
        user1 = FactoryGirl.create(:user)
        job = FactoryGirl.create(:job, owner: user1)
        params = { job_id: job.to_param, user: { id: user.to_param } }
        allow(NewApplicantNotifier).to receive(:call)
        post :create, params, valid_session
        expect(NewApplicantNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job_user as @job_user' do
        job = FactoryGirl.create(:job, owner: user)
        post :create, { job_id: job.to_param, user: {} }, valid_session
        expect(assigns(:job_user)).to be_a_new(JobUser)
      end

      it 'returns unprocessable entity status' do
        job = FactoryGirl.create(:job, owner: user)
        post :create, { job_id: job.to_param, user: {} }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            attributes: { accepted: true }
          }
        }
      end

      context 'job owner user' do
        it 'updates the requested job' do
          job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
          user = job.users.first
          job_user = job.job_users.first
          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          job_user.reload
          expect(job_user.accepted).to eq(true)
        end

        it 'assigns the requested user as @job' do
          job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
          user = job.users.first
          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          expect(assigns(:job)).to eq(job)
        end

        it 'returns 200 ok status' do
          job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
          user = job.users.first
          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          expect(response.status).to eq(200)
        end

        it 'notifies user when updated Job#performed_accept is set to true' do
          job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
          user = job.users.first
          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          allow(ApplicantAcceptedNotifier).to receive(:call).with(job: job, user: user)
          put :update, params, valid_session
          expect(ApplicantAcceptedNotifier).to have_received(:call)
        end

        it 'notifies user when updated #performed_accepted to true' do
          new_performed_attributes = {
            data: {
              attributes: { performed_accepted: true }
            }
          }
          job = FactoryGirl.create(:job, owner: user)
          job_user = FactoryGirl.create(:job_user_will_perform, job: job)
          user = job_user.user
          params = {
            job_id: job.to_param, id: user.to_param
          }.merge(new_performed_attributes)
          allow(JobUserPerformedAcceptedNotifier).to receive(:call).
            with(job: job, user: user)
          put :update, params, valid_session
          expect(JobUserPerformedAcceptedNotifier).to have_received(:call)
        end
      end

      context 'non associated user' do
        let(:new_attributes) do
          {}
        end

        it 'returns forbidden status' do
          job = FactoryGirl.create(:job_with_users, users_count: 1)
          user = job.users.first
          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          expect(response.status).to eq(401)
        end
      end

      context 'job user' do
        let(:new_attributes) do
          {
            data: {
              attributes: { will_perform: true }
            }
          }
        end

        it 'notifies user when updated Job#performed_accept is set to true' do
          job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
          user = job.users.first
          job_user = job.job_users.first
          job_user.accepted = true
          job_user.save!

          allow_any_instance_of(described_class).
            to(receive(:authenticate_user_token!).
            and_return(user))

          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          allow(ApplicantWillPerformNotifier).to receive(:call).with(job: job, user: user)
          put :update, params, valid_session
          expect(ApplicantWillPerformNotifier).to have_received(:call)
        end

        it 'can set #will_perform attribute' do
          job = FactoryGirl.create(:job_with_users, users_count: 1)
          user = job.users.first
          job_user = job.job_users.first
          job_user.accepted = true
          job_user.save!

          allow_any_instance_of(described_class).
            to(receive(:authenticate_user_token!).
            and_return(user))

          params = { job_id: job.to_param, id: user.to_param }.merge(new_attributes)
          put :update, params, {}
          job_user.reload
          expect(job_user.will_perform).to eq(true)
        end

        it 'notifies owner when updated #performed is set to true' do
          new_performed_attributes = {
            data: {
              attributes: { performed: true }
            }
          }
          job = FactoryGirl.create(:job, owner: user)
          job_user = FactoryGirl.create(:job_user_will_perform, job: job)
          user = job_user.user
          params = {
            job_id: job.to_param, id: user.to_param
          }.merge(new_performed_attributes)

          allow_any_instance_of(described_class).
            to(receive(:authenticate_user_token!).
            and_return(user))

          allow(JobUserPerformedNotifier).to receive(:call).with(job: job, user: user)
          put :update, params, valid_session
          expect(JobUserPerformedNotifier).to have_received(:call)
        end
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
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        expect do
          delete :destroy, params, session
        end.to change(JobUser, :count).by(-1)
      end

      it 'can *not* be destroyed if JobUser#will_perform is true' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        job.job_users.first.update_attributes(accepted: true, will_perform: true)
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        delete :destroy, params, session
        err_msg = "can't delete when will perform is true"
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['will_perform'].first).to eq(err_msg)
      end

      it 'sends a notificatiom to Job#owner if accepted applicant withdraws' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        job.job_users.first.update_attributes(accepted: true)
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        allow(AcceptedApplicantWithdrawnNotifier).to receive(:call)
        delete :destroy, params, session
        expect(AcceptedApplicantWithdrawnNotifier).to have_received(:call)
      end

      it 'returns no content status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(user))
        session = { token: user.auth_token }
        params = { job_id: job.to_param, id: user.to_param }
        delete :destroy, params, session
        expect(response.status).to eq(204)
      end
    end
  end
end
