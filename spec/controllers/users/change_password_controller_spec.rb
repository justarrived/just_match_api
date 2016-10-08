# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::ChangePasswordController, type: :controller do
  describe 'POST #create' do
    let(:old_password) { 'OLD PASSWORD' }
    let(:new_password) { 'NEW PASSWORD' }
    let!(:user) { FactoryGirl.create(:user_with_one_time_token, password: old_password) }

    context 'logged in user' do
      let(:valid_attributes) do
        {
          data: {
            attributes: {
              old_password: old_password,
              password: new_password
            }
          }
        }
      end

      let(:valid_session) do
        allow_any_instance_of(described_class).
          to(receive(:current_user).
          and_return(user))
        {}
      end

      it 'changes the user password' do
        post :create, valid_attributes, valid_session
        expect(User.correct_password?(assigns(:user), new_password)).to eq(true)
      end

      it 'returns 200 ok sucessfull password update' do
        post :create, valid_attributes, valid_session
        expect(response.status).to eq(200)
      end

      it 'destroys all user tokens' do
        user.create_auth_token

        post :create, valid_attributes, valid_session

        expect(assigns(:user).auth_tokens.length).to be_zero
      end
    end

    context 'valid one time token' do
      let(:valid_attributes) do
        {
          data: {
            attributes: {
              password: new_password,
              one_time_token: user.one_time_token
            }
          }
        }
      end

      let(:invalid_attributes) do
        {
          data: {
            attributes: {
              password: nil,
              one_time_token: user.one_time_token
            }
          }
        }
      end

      context 'with valid params' do
        it 'returns 200 ok status' do
          post :create, valid_attributes, {}
          expect(response.status).to eq(200)
        end

        it 'sends changed password email' do
          allow(ChangedPasswordNotifier).to receive(:call).with(user: user)
          post :create, valid_attributes, {}
          expect(ChangedPasswordNotifier).to have_received(:call)
        end

        it 'changes the user password' do
          post :create, valid_attributes, {}
          expect(User.correct_password?(assigns(:user), new_password)).to eq(true)
        end

        it 'regenerates the users one time token' do
          before_token = user.one_time_token
          post :create, valid_attributes, {}
          expect(assigns(:user).one_time_token).not_to eq(before_token)
        end
      end

      context 'with invalid params' do
        it 'returns 422 unprocessable entity status' do
          post :create, invalid_attributes, {}
          expect(response.status).to eq(422)
        end

        it 'returns with error message' do
          post :create, invalid_attributes, {}
          parsed_json = JSON.parse(response.body)
          min_length = User::MIN_PASSWORD_LENGTH
          message = I18n.t('errors.user.password_length', count: min_length)
          expect(parsed_json['errors'].first['detail']).to eq(message)
        end
      end
    end
  end
end
