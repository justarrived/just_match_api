require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, type: :controller do
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
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      skill = user.skills.first
      get :index, { user_id: user.to_param }, {}
      expect(assigns(:skills)).to eq([skill])
    end

    it 'returns 200 ok status' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      skill = user.skills.first
      get :index, { user_id: user.to_param }, {}
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      skill = user.skills.first
      params = { user_id: user.to_param, id: skill.to_param }
      get :show, params, valid_session
      expect(assigns(:skill)).to eq(skill)
    end

    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user_with_skills, skills_count: 1)
      skill = user.skills.first
      params = { user_id: user.to_param, id: skill.to_param }
      get :show, params, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'authorized user' do
        let(:user) { User.find_by(auth_token: valid_session[:token]) }

        it 'creates a new UserSkill' do
          skill = FactoryGirl.create(:skill)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param }
            }
          }
          expect do
            post :create, params, valid_session
          end.to change(UserSkill, :count).by(1)
        end

        it 'assigns a newly created user_skill as @user_skill' do
          skill = FactoryGirl.create(:skill)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param }
            }
          }
          post :create, params, valid_session
          expect(assigns(:user_skill)).to be_a(UserSkill)
          expect(assigns(:user_skill)).to be_persisted
        end

        it 'returns created status' do
          skill = FactoryGirl.create(:skill)
          params = {
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param }
            }
          }
          post :create, params, valid_session
          expect(response.status).to eq(201)
        end
      end
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(nil))
        user = FactoryGirl.create(:user)
        post :create, { user_id: user.to_param, skill: {} }, {}
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid params' do
      context 'authorized user' do
        let(:user) { User.find_by(auth_token: valid_session[:token]) }

        it 'assigns a newly created but unsaved user_skill as @user_skill' do
          post :create, { user_id: user.to_param, skill: {} }, valid_session
          expect(assigns(:user_skill)).to be_a_new(UserSkill)
        end

        it 'returns unprocessable entity status' do
          post :create, { user_id: user.to_param, skill: {} }, valid_session
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user' do
      let(:valid_session) do
        user = FactoryGirl.create(:user_with_skills)
        allow_any_instance_of(described_class).
          to(receive(:authenticate_user_token!).
          and_return(user))
        { token: user.auth_token }
      end

      let(:user) { User.find_by(auth_token: valid_session[:token]) }

      it 'destroys the requested user_skill' do
        skill = user.skills.first
        expect do
          params = { user_id: user.to_param, id: skill.to_param }
          delete :destroy, params, valid_session
        end.to change(UserSkill, :count).by(-1)
      end

      it 'returns no content status' do
        skill = user.skills.first
        params = { user_id: user.to_param, id: skill.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'unauthorized user' do
      it 'does not destroy the requested user_skill' do
        user = FactoryGirl.create(:user_with_skills)
        skill = user.skills.first
        expect do
          params = { user_id: user.to_param, id: skill.to_param }
          delete :destroy, params, valid_session
        end.to change(UserSkill, :count).by(0)
      end

      it 'returns not authorized status' do
        user = FactoryGirl.create(:user_with_skills)
        skill = user.skills.first
        params = { user_id: user.to_param, id: skill.to_param }
        delete :destroy, params, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
