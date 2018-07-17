# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BaseController', type: :request do
  describe 'authenticate_user_token!' do
    context 'with valid token' do
      let(:token) { FactoryBot.create(:token) }
      let(:auth_header) do
        encoded_token = ActionController::HttpAuthentication::Token.encode_credentials(token.token) # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns user if passed valid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), headers: auth_header

        parsed_body = JSON.parse(response.body)
        first_name = parsed_body.dig('data', 'attributes', 'first_name')

        expect(first_name).to eq('Jane')
      end
    end

    context 'with invalid token' do
      let(:token) { FactoryBot.create(:token) }
      let(:auth_header) do
        encoded_token = ActionController::HttpAuthentication::Token.encode_credentials('notavalidtoken') # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns unauthorized if passed invalid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), headers: auth_header

        expect(response.code).to eq('401')
      end
    end

    context 'with expired token' do
      let(:token) { FactoryBot.create(:expired_token) }
      let(:auth_header) do
        encoded_token = ActionController::HttpAuthentication::Token.encode_credentials(token.token) # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns unauthorized if passed invalid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), headers: auth_header

        parsed_body = JSON.parse(response.body)
        errors = parsed_body.dig('errors').first
        expect(errors['status']).to eq(401)
        expect(errors['detail']).to eq(I18n.t('token_expired_error'))
        expect(errors['code']).to eq('token_expired')
      end
    end
  end
end
