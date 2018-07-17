# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) do
    user = FactoryBot.create(:user_with_tokens, company: FactoryBot.create(:company))
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all user skills as @skills' do
      job = FactoryBot.create(:job_with_skills, skills_count: 1)
      job_skill = job.job_skills.first
      get :index, params: { job_id: job.to_param }
      expect(assigns(:job_skills)).to eq([job_skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill' do
      job = FactoryBot.create(:job_with_skills, skills_count: 1)
      job_skill = job.job_skills.first
      params = { job_id: job.to_param, job_skill_id: job_skill.to_param }
      get :show, params: params
      expect(assigns(:job_skill)).to eq(job_skill)
    end

    it 'assigns the requested user as @user' do
      job = FactoryBot.create(:job_with_skills, skills_count: 1)
      job_skill = job.job_skills.first
      params = { job_id: job.to_param, job_skill_id: job_skill.to_param }
      get :show, params: params
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'logged in' do
        let(:user) { FactoryBot.create(:company_user).tap(&:create_auth_token) }

        it 'creates a new JobSkill' do
          job = FactoryBot.create(:job, owner: user)
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          expect do
            post :create, params: params
          end.to change(JobSkill, :count).by(1)
        end

        it 'assigns a newly created user_skill as @job_skill' do
          job = FactoryBot.create(:job, owner: user)
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          post :create, params: params
          expect(assigns(:job_skill)).to be_a(JobSkill)
          expect(assigns(:job_skill)).to be_persisted
        end

        it 'returns created status' do
          job = FactoryBot.create(:job, owner: user)
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          post :create, params: params
          expect(response.status).to eq(201)
        end
      end

      context 'not logged in' do
        it 'does not create a new JobSkill' do
          job = FactoryBot.create(:job)
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: 'wat',
            job_id: job.to_param,
            data: { id: skill.to_param }
          }
          expect do
            post :create, params: params
          end.to change(JobSkill, :count).by(0)
        end
      end
    end

    context 'with invalid params' do
      let(:user) { FactoryBot.create(:company_user).tap(&:create_auth_token) }

      it 'assigns a newly created but unsaved job_skill as @job_skill' do
        job = FactoryBot.create(:job, owner: user)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          skill: {}
        }
        post :create, params: params
        expect(assigns(:job_skill)).to be_a_new(JobSkill)
      end

      it 'returns unprocessable entity status' do
        job = FactoryBot.create(:job, owner: user)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          skill: {}
        }
        post :create, params: params
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'logged in user is owner' do
      let(:user) { FactoryBot.create(:company_user).tap(&:create_auth_token) }

      it 'destroys the requested job_skill' do
        job = FactoryBot.create(:job_with_skills, owner: user)
        job_skill = job.job_skills.first
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_skill_id: job_skill.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(JobSkill, :count).by(-1)
      end

      it 'returns no content status' do
        job = FactoryBot.create(:job_with_skills, owner: user)
        job_skill = job.job_skills.first
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_skill_id: job_skill.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
      end
    end

    context 'logged in user is NOT owner' do
      it 'destroys the requested job_skill' do
        job = FactoryBot.create(:job_with_skills)
        job_skill = job.job_skills.first
        params = {
          auth_token: 'wat',
          job_id: job.to_param,
          job_skill_id: job_skill.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(JobSkill, :count).by(0)
      end

      it 'returns no content status' do
        job = FactoryBot.create(:job_with_skills)
        job_skill = job.job_skills.first
        random_user = FactoryBot.create(:user_with_tokens)
        params = {
          auth_token: random_user.auth_token,
          job_id: job.to_param,
          job_skill_id: job_skill.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(403)
      end
    end
  end
end
