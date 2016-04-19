# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserImagesController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) do
      { image: TestImageFileReader.image }
    end

    let(:invalid_attributes) do
      {}
    end

    context 'with valid params' do
      it 'saves user image' do
        post :create, valid_attributes, {}
        expect(assigns(:user_image)).to be_persisted
      end

      it 'returns 201 accepted status' do
        post :create, valid_attributes, {}
        assigns(:user_image)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'returns 422 accepted status' do
        post :create, invalid_attributes, {}
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_image) { FactoryGirl.create(:user_image, user: user) }
    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      {}
    end

    it 'returns user image' do
      get :show, { user_id: user.to_param, id: user_image.to_param }, valid_session
      expect(assigns(:user_image)).to eq(user_image)
    end

    it 'returns 200 ok status' do
      get :show, { user_id: user.to_param, id: user_image.to_param }, valid_session
      assigns(:user_image)
      expect(response.status).to eq(200)
    end
  end
end
