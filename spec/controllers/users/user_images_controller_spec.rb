# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserImagesController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:category) { UserImage::CATEGORIES.keys.last }
    let(:valid_params) do
      {
        user_id: user.to_param,
        data: {
          attributes: {
            image: TestImageFileReader.image,
            category: category
          }
        }
      }
    end

    let(:invalid_params) do
      { user_id: user.to_param }
    end

    context 'with valid params' do
      it 'saves user image' do
        post :create, params: valid_params
        expect(assigns(:user_image)).to be_persisted
      end

      it 'returns 201 accepted status' do
        post :create, params: valid_params
        expect(response.status).to eq(201)
      end

      it 'assigns the user image category' do
        post :create, params: valid_params
        user_image = assigns(:user_image)
        expect(user_image.category).to eq(category.to_s)
      end

      it 'assigns the user image user' do
        post :create, params: valid_params
        user_image = assigns(:user_image)
        expect(user_image.user).to eq(user)
      end
    end

    context 'with invalid params' do
      it 'returns 422 accepted status' do
        post :create, params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_image) { FactoryGirl.create(:user_image, user: user) }
    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      {}
    end

    it 'returns user image' do
      get :show, params: { user_id: user.to_param, id: user_image.to_param }, headers: valid_session # rubocop:disable Metrics/LineLength
      expect(assigns(:user_image)).to eq(user_image)
    end

    it 'returns 200 ok status' do
      get :show, params: { user_id: user.to_param, id: user_image.to_param }, headers: valid_session # rubocop:disable Metrics/LineLength
      assigns(:user_image)
      expect(response.status).to eq(200)
    end
  end
end
