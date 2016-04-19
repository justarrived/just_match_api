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
end
