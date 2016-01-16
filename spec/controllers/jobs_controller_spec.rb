require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  let(:valid_attributes) do
    {
      skill_ids: [FactoryGirl.create(:skill).id],
      max_rate: 150,
      estimated_completion_time: 2,
      name: 'Some job name',
      description: 'Some job description',
      language_id: FactoryGirl.create(:language).id,
      owner_user_id: FactoryGirl.create(:user).id,
      address: 'Stora Nygatan 36, Malmö',
      job_date: 1.day.from_now
    }
  end

  let(:invalid_attributes) do
    { max_rate: nil }
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all jobs as @jobs' do
      Job.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:jobs).first).to be_a(Job)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested job as @job' do
      job = FactoryGirl.create(:job)
      get :show, { job_id: job.to_param }, valid_session
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Job' do
        expect do
          post :create, { job: valid_attributes }, valid_session
        end.to change(Job, :count).by(1)
      end

      it 'assigns a newly created job as @job' do
        post :create, { job: valid_attributes }, valid_session
        expect(assigns(:job)).to be_a(Job)
        expect(assigns(:job)).to be_persisted
      end

      it 'resturns created status' do
        post :create, { job: valid_attributes }, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job as @job' do
        post :create, { job: invalid_attributes }, valid_session
        expect(assigns(:job)).to be_a_new(Job)
      end

      it 'returns 422 status' do
        post :create, { job: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { max_rate: 150 }
      end

      before(:each) do
        @user = User.find_by(auth_token: valid_session[:token])
      end

      context 'owner user' do
        it 'updates the requested job' do
          job = FactoryGirl.create(:job, owner: @user)
          params = { job_id: job.to_param, job: new_attributes }
          put :update, params, valid_session
          job.reload
          expect(job.max_rate).to eq(150)
        end

        it 'assigns the requested user as @job' do
          job = FactoryGirl.create(:job)
          params = { job_id: job.to_param, job: new_attributes }
          put :update, params, valid_session
          expect(assigns(:job)).to eq(job)
        end

        it 'returns success status' do
          job = FactoryGirl.create(:job, owner: @user)
          params = { job_id: job.to_param, job: new_attributes }
          put :update, params, valid_session
          expect(response.status).to eq(200)
        end

        it 'notifies user when updated Job#performed_accept is set to true' do
          FactoryGirl.create(:user)
          job = FactoryGirl.create(:job, owner: @user)
          params = { job_id: job.to_param, job: { performed_accept: true } }
          allow(JobPerformedAcceptNotifier).to receive(:call).with(job: job)
          put :update, params, valid_session
          expect(JobPerformedAcceptNotifier).to have_received(:call)
        end
      end

      context 'non associated user' do
        let(:new_attributes) do
          { performed: true }
        end

        it 'updates the requested job' do
          FactoryGirl.create(:user)
          user1 = FactoryGirl.create(:user)
          user2 = FactoryGirl.create(:user)
          job = FactoryGirl.create(:job, owner: user1)
          FactoryGirl.create(:job_user, user: user2, job: job, accepted: true)
          put :update, { job_id: job.to_param, job: new_attributes }, valid_session
          job.reload
          expect(job.performed).to eq(false)
        end

        it 'returns forbidden status' do
          FactoryGirl.create(:user)
          user1 = FactoryGirl.create(:user)
          user2 = FactoryGirl.create(:user)
          job = FactoryGirl.create(:job, owner: user1)
          FactoryGirl.create(:job_user, user: user2, job: job, accepted: true)
          put :update, { job_id: job.to_param, job: new_attributes }, valid_session
          expect(response.status).to eq(401)
        end
      end

      context 'job user' do
        let(:new_attributes) do
          { performed: true }
        end

        let(:valid_session) do
          user = FactoryGirl.create(:user)
          allow_any_instance_of(described_class).
            to(receive(:authenticate_user_token!).
            and_return(user))
          { token: user.auth_token }
        end

        before(:each) do
          @user = User.find_by(auth_token: valid_session[:token])
        end

        it 'updates the requested job' do
          job = FactoryGirl.create(:job)
          FactoryGirl.create(:job_user, user: @user, job: job, accepted: true)
          put :update, { job_id: job.to_param, job: new_attributes }, valid_session
          job.reload
          expect(job.performed).to eq(true)
        end

        it 'assigns the requested job as @job' do
          FactoryGirl.create(:user)
          job = FactoryGirl.create(:job)
          FactoryGirl.create(:job_user, user: @user, job: job, accepted: true)
          put :update, { job_id: job.to_param, job: new_attributes }, valid_session
          expect(assigns(:job)).to eq(job)
        end

        it 'returns success status' do
          FactoryGirl.create(:user)
          job = FactoryGirl.create(:job)
          FactoryGirl.create(:job_user, user: @user, job: job, accepted: true)
          put :update, { job_id: job.to_param, job: new_attributes }, valid_session
          expect(response.status).to eq(200)
        end

        it 'notifies owner when updated Job#performed is set to true' do
          FactoryGirl.create(:user)
          job = FactoryGirl.create(:job)
          FactoryGirl.create(:job_user, user: @user, job: job, accepted: true)
          params = { job_id: job.to_param, job: { performed: true } }
          allow(JobPerformedNotifier).to receive(:call).with(job: job)
          put :update, params, valid_session
          expect(JobPerformedNotifier).to have_received(:call)
        end
      end
    end

    context 'with invalid params' do
      before(:each) do
        user = User.find_by(auth_token: valid_session[:token])
        @job = FactoryGirl.create(:job, owner: user)
      end

      it 'assigns the job as @job' do
        put :update, { job_id: @job.to_param, job: invalid_attributes }, valid_session
        expect(assigns(:job)).to eq(@job)
      end

      it 'returns unprocessable entity status' do
        put :update, { job_id: @job.to_param, job: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  max_rate                  :integer
#  description               :text
#  job_date                  :datetime
#  performed_accept          :boolean          default(FALSE)
#  performed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  owner_user_id             :integer
#  latitude                  :float
#  longitude                 :float
#  address                   :string
#  name                      :string
#  estimated_completion_time :float
#  language_id               :integer
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57  (language_id => languages.id)
#
