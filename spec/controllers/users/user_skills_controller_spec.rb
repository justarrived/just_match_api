require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # UserSkill. As you add validations to UserSkill, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {}
  }

  let(:invalid_attributes) {
    {}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UserSkillsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all user skills as @skills' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      skill = user.skills.first
      get :index, {user_id: user.to_param}, valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      skill = user.skills.first
      get :show, {user_id: user.to_param, id: skill.to_param}, valid_session
      expect(assigns(:skill)).to eq(skill)
    end

    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      skill = user.skills.first
      get :show, {user_id: user.to_param, id: skill.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new UserSkill' do
        user = FactoryGirl.create(:user)
        skill = FactoryGirl.create(:skill)
        expect {
          post :create, {user_id: user.to_param, skill: {id: skill.to_param}}, valid_session
        }.to change(UserSkill, :count).by(1)
      end

      it 'assigns a newly created user_skill as @user_skill' do
        user = FactoryGirl.create(:user)
        skill = FactoryGirl.create(:skill)
        post :create, {user_id: user.to_param, skill: {id: skill.to_param}}, valid_session
        expect(assigns(:user_skill)).to be_a(UserSkill)
        expect(assigns(:user_skill)).to be_persisted
      end

      it 'returns created status' do
        user = FactoryGirl.create(:user)
        skill = FactoryGirl.create(:skill)
        post :create, {user_id: user.to_param, skill: {id: skill.to_param}}, valid_session
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user_skill as @user_skill' do
        user = FactoryGirl.create(:user)
        post :create, {user_id: user.to_param, skill: {}}, valid_session
        expect(assigns(:user_skill)).to be_a_new(UserSkill)
      end

      it 'returns unprocessable entity status' do
        user = FactoryGirl.create(:user)
        post :create, {user_id: user.to_param, skill: {}}, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user_skill' do
      user = FactoryGirl.create(:user_with_skills)
      skill = user.skills.first
      expect {
        delete :destroy, {user_id: user.to_param, id: skill.to_param}, valid_session
      }.to change(UserSkill, :count).by(-1)
    end

    it 'returns no content status' do
      user = FactoryGirl.create(:user_with_skills)
      skill = user.skills.first
      delete :destroy, {user_id: user.to_param, id: skill.to_param}, valid_session
      expect(response.status).to eq(204)
    end
  end
end
