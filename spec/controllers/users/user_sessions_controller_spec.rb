# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserSessionsController, type: :controller do
  let(:email) { 'someone@example.com' }
  let(:password) { '12345678' }
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          email_or_phone: email,
          password: password
        }
      }
    }
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_session) { {} }

  describe 'POST #create' do
    context 'valid user' do
      context 'with email given' do
        before(:each) do
          attrs = { email: email, password: password }
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
          expect(jsonapi_params['auth_token'].length).to eq(36)
        end

        it 'should return JSON with user id' do
          post :create, valid_attributes, valid_session
          json = JSON.parse(response.body)
          jsonapi_params = JsonApiDeserializer.parse(json)
          expect(jsonapi_params['user_id']).not_to be_nil
        end

        context 'promo code' do
          before(:each) do
            Rails.configuration.x.promo_code = 'test_promo_code'
          end

          after(:each) do
            Rails.configuration.x.promo_code = nil
          end

          it 'lets the request pass even if there is a promo code' do
            post :create, valid_attributes, valid_session
            expect(response.status).to eq(201)
          end
        end
      end

      context 'with phone given' do
        it 'should return success status' do
          password = '12345678'
          user = FactoryGirl.create(:user, password: password)
          valid_attributes = {
            data: {
              attributes: {
                email_or_phone: user.phone,
                password: password
              }
            }
          }

          post :create, valid_attributes, valid_session
          expect(response.status).to eq(201)
        end
      end
    end

    context 'invalid user' do
      it 'should return forbidden status' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(422)
      end

      it 'returns explaination' do
        post :create, valid_attributes, valid_session
        message = I18n.t('errors.user_session.wrong_email_or_phone_or_password')
        json = JSON.parse(response.body)
        first_detail = json['errors'].first['detail']
        last_detail = json['errors'].last['detail']

        # The message for both password & email should be the same
        expect(first_detail).to eq(message)
        expect(last_detail).to eq(message)
      end
    end

    context 'banned user' do
      before(:each) do
        attrs = { email: 'someone@example.com', password: '12345678', banned: true }
        FactoryGirl.create(:user, attrs)
      end

      it 'returns forbidden status' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(403)
      end

      it 'returns explaination' do
        post :create, valid_attributes, valid_session
        json = JSON.parse(response.body)
        message = 'an admin has banned'
        detail = json['errors'].first['detail']
        expect(detail.starts_with?(message)).to eq(true)
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

    context 'no such user auth_token' do
      it 'should return 404 not found' do
        FactoryGirl.create(:user, email: 'someone@example.com')
        delete :destroy, { id: 'dasds' }, {}
        expect(response.status).to eq(404)
      end
    end
  end
end
