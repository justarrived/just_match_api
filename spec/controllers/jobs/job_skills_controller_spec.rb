require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, type: :controller do
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

  describe 'GET #index' do
    it 'assigns all user skills as @skills' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :index, { job_id: job.to_param }, valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :show, { job_id: job.to_param, id: skill.to_param }, valid_session
      expect(assigns(:skill)).to eq(skill)
    end

    it 'assigns the requested user as @user' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :show, { job_id: job.to_param, id: skill.to_param }, valid_session
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'logged in' do
        let(:user) { User.find_by(auth_token: valid_session[:token]) }

        it 'creates a new JobSkill' do
          job = FactoryGirl.create(:job, owner: user)
          skill = FactoryGirl.create(:skill)
          params = {
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          expect do
            post :create, params, valid_session
          end.to change(JobSkill, :count).by(1)
        end

        it 'assigns a newly created user_skill as @job_skill' do
          job = FactoryGirl.create(:job, owner: user)
          skill = FactoryGirl.create(:skill)
          params = {
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          post :create, params, valid_session
          expect(assigns(:job_skill)).to be_a(JobSkill)
          expect(assigns(:job_skill)).to be_persisted
        end

        it 'returns created status' do
          job = FactoryGirl.create(:job, owner: user)
          skill = FactoryGirl.create(:skill)
          params = {
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          post :create, params, valid_session
          expect(response.status).to eq(201)
        end
      end

      context 'not logged in' do
        it 'does not create a new JobSkill' do
          job = FactoryGirl.create(:job)
          skill = FactoryGirl.create(:skill)
          params = {
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          expect do
            post :create, params, valid_session
          end.to change(JobSkill, :count).by(0)
        end
      end
    end

    context 'with invalid params' do
      let(:user) { User.find_by(auth_token: valid_session[:token]) }

      it 'assigns a newly created but unsaved job_skill as @job_skill' do
        job = FactoryGirl.create(:job, owner: user)
        post :create, { job_id: job.to_param, skill: {} }, valid_session
        expect(assigns(:job_skill)).to be_a_new(JobSkill)
      end

      it 'returns unprocessable entity status' do
        job = FactoryGirl.create(:job, owner: user)
        post :create, { job_id: job.to_param, skill: {} }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'logged in user is owner' do
      let(:user) { User.find_by(auth_token: valid_session[:token]) }

      it 'destroys the requested job_skill' do
        job = FactoryGirl.create(:job_with_skills, owner: user)
        skill = job.skills.first
        expect do
          params = { job_id: job.to_param, id: skill.to_param }
          delete :destroy, params, valid_session
        end.to change(JobSkill, :count).by(-1)
      end

      it 'returns no content status' do
        job = FactoryGirl.create(:job_with_skills, owner: user)
        skill = job.skills.first
        params = { job_id: job.to_param, id: skill.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'logged in user is NOT owner' do
      it 'destroys the requested job_skill' do
        job = FactoryGirl.create(:job_with_skills)
        skill = job.skills.first
        expect do
          params = { job_id: job.to_param, id: skill.to_param }
          delete :destroy, params, valid_session
        end.to change(JobSkill, :count).by(0)
      end

      it 'returns no content status' do
        job = FactoryGirl.create(:job_with_skills)
        skill = job.skills.first
        params = { job_id: job.to_param, id: skill.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
