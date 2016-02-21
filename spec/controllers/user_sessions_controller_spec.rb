# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::UserSessionsController, type: :controller do
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          email: 'someone@example.com',
          password: '12345678'
        }
      }
    }
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) { {} }

  describe 'POST #token' do
    context 'valid user' do
      before(:each) do
        attrs = { email: 'someone@example.com', password: '12345678' }
        FactoryGirl.create(:user, attrs)
      end

      it 'should return success status' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(201)
      end

      it 'should return JSON with token key' do
        post :create, valid_attributes, valid_session
        json = JSON.parse(response.body)
        jsonapi_params = JsonApiDeserializer.parse(json)
        expect(jsonapi_params['auth_token'].length).to eq(32)
      end
    end

    context 'invalid user' do
      it 'should return forbidden status' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #token' do
    context 'valid user' do
      it 'should return success status' do
        user = FactoryGirl.create(:user, email: 'someone@example.com')
        token = user.auth_token
        delete :destroy, { id: token }, {}
        expect(response.status).to eq(204)
      end

      it 'should re-generate user auth token' do
        user = FactoryGirl.create(:user, email: 'someone@example.com')
        token = user.auth_token
        delete :destroy, { id: token }, {}
        user.reload
        expect(user.auth_token).not_to eq(token)
      end
    end

    context 'invalid user' do
      it 'should return unprocessable entity status' do
        FactoryGirl.create(:user, email: 'someone@example.com')
        delete :destroy, { id: 'dasds' }, {}
        expect(response.status).to eq(422)
      end
    end
  end
end
