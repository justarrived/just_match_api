# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, type: :controller do
  let(:valid_attributes) do
    {}
  end

  let(:invalid_attributes) do
    {}
  end

  describe 'GET #index' do
    it 'assigns all user skills as @skills' do
      user = FactoryBot.create(:user_with_skills, skills_count: 2)
      user.user_skills.first.update(proficiency: 3)
      user.user_skills.last.skill.update(internal: true)

      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      user_skill = user.user_skills.first
      get :index, params: { user_id: user.to_param }
      expect(assigns(:user_skills)).to eq([user_skill])
    end

    it 'does not return internal skills' do
      user = FactoryBot.create(:user_with_skills, skills_count: 1)
      user.user_skills.first.skill.update(internal: true)

      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))

      get :index, params: { user_id: user.to_param }
      expect(assigns(:user_skills)).to eq([])
    end

    it 'returns 200 ok status' do
      user = FactoryBot.create(:user)
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      get :index, params: { user_id: user.to_param }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user skill as @skill, @user_skill, @user' do
      user = FactoryBot.create(:user_with_skills, skills_count: 1)
      user_skill = user.user_skills.first
      skill = user_skill.skill
      params = {
        auth_token: user.auth_token,
        user_id: user.to_param,
        user_skill_id: user_skill.to_param
      }
      get :show, params: params

      expect(assigns(:skill)).to eq(skill)
      expect(assigns(:user_skill)).to eq(user_skill)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      context 'authorized user' do
        let(:user) { FactoryBot.create(:user_with_tokens) }

        it 'creates a new UserSkill' do
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param }
            }
          }
          expect do
            post :create, params: params
          end.to change(UserSkill, :count).by(1)
        end

        it 'assigns a newly created user_skill as @user_skill' do
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param, proficiency: 5 }
            }
          }
          post :create, params: params
          expect(assigns(:user_skill)).to be_a(UserSkill)
          expect(assigns(:user_skill)).to be_persisted
          expect(assigns(:user_skill).proficiency).to eq(5)
        end

        it 'returns created status' do
          skill = FactoryBot.create(:skill)
          params = {
            auth_token: user.auth_token,
            user_id: user.to_param,
            data: {
              attributes: { id: skill.to_param }
            }
          }
          post :create, params: params
          expect(response.status).to eq(201)
        end
      end
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(User.new))
        user = FactoryBot.create(:user)
        post :create, params: { auth_token: 'wat', user_id: user.to_param, skill: {} }
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid params' do
      context 'authorized user' do
        let(:user) { FactoryBot.create(:user_with_tokens) }

        it 'assigns a newly created but unsaved user_skill as @user_skill' do
          params = { auth_token: user.auth_token, user_id: user.to_param, skill: {} }
          post :create, params: params
          expect(assigns(:user_skill)).to be_a_new(UserSkill)
        end

        it 'returns unprocessable entity status' do
          params = { auth_token: user.auth_token, user_id: user.to_param, skill: {} }
          post :create, params: params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized user' do
      let(:user) do
        FactoryBot.create(:user_with_skills).tap do |user|
          user.create_auth_token
          user
        end
      end

      it 'destroys the requested user_skill' do
        user_skill = user.user_skills.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_skill_id: user_skill.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserSkill, :count).by(-1)
      end

      it 'does *not* destroy the requested user_skill if touched by admin' do
        user_skill = user.user_skills.first
        user_skill.update(proficiency_by_admin: 5)

        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_skill_id: user_skill.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserSkill, :count).by(0)
      end

      it 'returns no content status' do
        user_skill = user.user_skills.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_skill_id: user_skill.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
      end
    end

    context 'user not allowed' do
      it 'does not destroy the requested user_skill' do
        user = FactoryBot.create(:user_with_skills)
        user_skill = user.user_skills.first
        params = {
          auth_token: user.auth_token,
          user_id: user.to_param,
          user_skill_id: user_skill.to_param
        }
        expect do
          delete :destroy, params: params
        end.to change(UserSkill, :count).by(0)
      end

      it 'returns not authorized status' do
        user = FactoryBot.create(:user_with_skills)
        other_user = FactoryBot.create(:user_with_tokens)
        user_skill = user.user_skills.first
        params = {
          auth_token: other_user.auth_token,
          user_id: user.to_param,
          user_skill_id: user_skill.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(403)
      end
    end
  end
end
