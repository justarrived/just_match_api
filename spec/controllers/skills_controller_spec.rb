# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:valid_attributes) do
    FactoryGirl.create(:admin_user)
    lang_id = FactoryGirl.create(:language).id
    {
      data: {
        attributes: {
          name: "Skill #{SecureGenerator.token(length: 32)}",
          language_id: lang_id
        }
      }
    }
  end

  let(:invalid_attributes) do
    {
      data: {
        attributes: {
          name: nil
        }
      }
    }
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all skills as @skills' do
      skill = FactoryGirl.create(:skill)
      process :index, method: :get, headers: valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested skill as @skill' do
      skill = FactoryGirl.create(:skill)
      get :show, params: { id: skill.to_param }, headers: valid_session
      expect(assigns(:skill)).to eq(skill)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        expect do
          post :create, params: valid_attributes, headers: valid_session
        end.to change(Skill, :count).by(1)
      end

      it 'assigns a newly created skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: valid_attributes, headers: valid_session
        expect(assigns(:skill)).to be_a(Skill)
        expect(assigns(:skill)).to be_persisted
      end

      it 'returns success status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: valid_attributes, headers: valid_session
        expect(response.status).to eq(201)
      end

      context 'user not allowed' do
        it 'returns forbidden status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :create, params: valid_attributes, headers: valid_session
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:skill)).to be_a_new(Skill)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, params: invalid_attributes, headers: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            attributes: { name: 'New skill name' }
          }
        }
      end

      it 'updates the requested skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, params: { id: skill.to_param }.merge(new_attributes), headers: valid_session # rubocop:disable Metrics/LineLength
        skill.reload
        expect(skill.original_name).to eq('New skill name')
      end

      it 'assigns the requested skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, params: { id: skill.to_param }.merge(new_attributes), headers: valid_session # rubocop:disable Metrics/LineLength
        expect(assigns(:skill)).to eq(skill)
      end

      it 'returns 200' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, params: { id: skill.to_param }.merge(new_attributes), headers: valid_session # rubocop:disable Metrics/LineLength
        expect(response.status).to eq(200)
      end

      context 'user not allowed' do
        it 'returns forbidden status' do
          skill = FactoryGirl.create(:skill)
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :update, params: { id: skill.to_param }.merge(new_attributes), headers: valid_session # rubocop:disable Metrics/LineLength
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      it 'returns 200' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, params: { id: skill.to_param }.merge(invalid_attributes), headers: valid_session # rubocop:disable Metrics/LineLength
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested skill' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = FactoryGirl.create(:skill)
      expect do
        delete :destroy, params: { id: skill.to_param }, headers: valid_session
      end.to change(Skill, :count).by(-1)
    end

    it 'redirects to the skills list' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = FactoryGirl.create(:skill)
      delete :destroy, params: { id: skill.to_param }, headers: valid_session
      expect(response.status).to eq(204)
    end

    context 'user not allowed' do
      it 'returns forbidden status' do
        skill = FactoryGirl.create(:skill)
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        delete :destroy, params: { id: skill.to_param, skill: valid_attributes }, headers: valid_session # rubocop:disable Metrics/LineLength
        expect(response.status).to eq(403)
      end
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  color       :string
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_07eab65450  (language_id => languages.id)
#
