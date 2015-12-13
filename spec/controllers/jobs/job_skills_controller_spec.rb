require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # JobSkill. As you add validations to JobSkill, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {}
  }

  let(:invalid_attributes) {
    {}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobSkillsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all user skills as @skills' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :index, {job_id: job.to_param}, valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :show, {job_id: job.to_param, id: skill.to_param}, valid_session
      expect(assigns(:skill)).to eq(skill)
    end

    it 'assigns the requested user as @user' do
      job = FactoryGirl.create(:job_with_skills, skills_count: 1)
      skill = job.skills.first
      get :show, {job_id: job.to_param, id: skill.to_param}, valid_session
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new JobSkill' do
        job = FactoryGirl.create(:job)
        skill = FactoryGirl.create(:skill)
        expect {
          post :create, {job_id: job.to_param, skill: {id: skill.to_param}}, valid_session
        }.to change(JobSkill, :count).by(1)
      end

      it 'assigns a newly created user_skill as @job_skill' do
        job = FactoryGirl.create(:job)
        skill = FactoryGirl.create(:skill)
        post :create, {job_id: job.to_param, skill: {id: skill.to_param}}, valid_session
        expect(assigns(:job_skill)).to be_a(JobSkill)
        expect(assigns(:job_skill)).to be_persisted
      end

      it 'returns created status' do
        job = FactoryGirl.create(:job)
        skill = FactoryGirl.create(:skill)
        post :create, {job_id: job.to_param, skill: {id: skill.to_param}}, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job_skill as @job_skill' do
        job = FactoryGirl.create(:job)
        post :create, {job_id: job.to_param, skill: {}}, valid_session
        expect(assigns(:job_skill)).to be_a_new(JobSkill)
      end

      it 'returns unprocessable entity status' do
        job = FactoryGirl.create(:job)
        post :create, {job_id: job.to_param, skill: {}}, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested job_skill' do
      job = FactoryGirl.create(:job_with_skills)
      skill = job.skills.first
      expect {
        delete :destroy, {job_id: job.to_param, id: skill.to_param}, valid_session
      }.to change(JobSkill, :count).by(-1)
    end

    it 'returns no content status' do
      job = FactoryGirl.create(:job_with_skills)
      skill = job.skills.first
      delete :destroy, {job_id: job.to_param, id: skill.to_param}, valid_session
      expect(response.status).to eq(204)
    end
  end
end
