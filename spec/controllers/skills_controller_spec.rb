# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  let(:valid_attributes) do
    FactoryGirl.create(:admin_user)
    lang_id = FactoryGirl.create(:language).id
    {
      data: {
        attributes: {
          name: "Skill #{SecureRandom.uuid}",
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
      get :index, {}, valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested skill as @skill' do
      skill = FactoryGirl.create(:skill)
      get :show, { id: skill.to_param }, valid_session
      expect(assigns(:skill)).to eq(skill)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        expect do
          post :create, valid_attributes, valid_session
        end.to change(Skill, :count).by(1)
      end

      it 'assigns a newly created skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, valid_attributes, valid_session
        expect(assigns(:skill)).to be_a(Skill)
        expect(assigns(:skill)).to be_persisted
      end

      it 'returns success status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(201)
      end

      context 'unauthorized user' do
        it 'returns unauthorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :create, valid_attributes, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, invalid_attributes, valid_session
        expect(assigns(:skill)).to be_a_new(Skill)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, invalid_attributes, valid_session
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
        put :update, { id: skill.to_param }.merge(new_attributes), valid_session
        skill.reload
        expect(skill.name).to eq('New skill name')
      end

      it 'assigns the requested skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, { id: skill.to_param }.merge(new_attributes), valid_session
        expect(assigns(:skill)).to eq(skill)
      end

      it 'returns 200' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, { id: skill.to_param }.merge(new_attributes), valid_session
        expect(response.status).to eq(200)
      end

      context 'unauthorized user' do
        it 'returns unauthorized status' do
          skill = FactoryGirl.create(:skill)
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :update, { id: skill.to_param }.merge(new_attributes), valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, { id: skill.to_param }.merge(invalid_attributes), valid_session
        expect(assigns(:skill)).to eq(skill)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = FactoryGirl.create(:skill)
        put :update, { id: skill.to_param }.merge(invalid_attributes), valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested skill' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = FactoryGirl.create(:skill)
      expect do
        delete :destroy, { id: skill.to_param }, valid_session
      end.to change(Skill, :count).by(-1)
    end

    it 'redirects to the skills list' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = FactoryGirl.create(:skill)
      delete :destroy, { id: skill.to_param }, valid_session
      expect(response.status).to eq(204)
    end

    context 'unauthorized user' do
      it 'returns unauthorized status' do
        skill = FactoryGirl.create(:skill)
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        delete :destroy, { id: skill.to_param, skill: valid_attributes }, valid_session
        expect(response.status).to eq(401)
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
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_07eab65450  (language_id => languages.id)
#
