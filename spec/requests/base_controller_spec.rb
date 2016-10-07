# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'BaseController', type: :request do
  describe 'authenticate_user_token!' do
    context 'with valid token' do
      let(:token) { FactoryGirl.create(:token) }
      let(:auth_header) do
        encoded_token =  ActionController::HttpAuthentication::Token.encode_credentials(token.token) # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns user if passed valid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), nil, auth_header

        parsed_body = JSON.parse(response.body)
        first_name = parsed_body.dig('data', 'attributes', 'first-name')

        expect(first_name).to eq('Jane')
      end
    end

    context 'with invalid token' do
      let(:token) { FactoryGirl.create(:token) }
      let(:auth_header) do
        encoded_token =  ActionController::HttpAuthentication::Token.encode_credentials('notavalidtoken') # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns unauthorized if passed invalid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), nil, auth_header

        expect(response.code).to eq('401')
      end
    end

    context 'with expired token' do
      let(:token) { FactoryGirl.create(:expired_token) }
      let(:auth_header) do
        encoded_token =  ActionController::HttpAuthentication::Token.encode_credentials(token.token) # rubocop:disable Metrics/LineLength
        { 'HTTP_AUTHORIZATION' => encoded_token }
      end

      it 'returns unauthorized if passed invalid token' do
        user = token.user

        get api_v1_user_path(user_id: user.id), nil, auth_header

        parsed_body = JSON.parse(response.body)
        errors = parsed_body.dig('errors').first
        expect(errors['status']).to eq(401)
        expect(errors['detail']).to eq(I18n.t('token_expired_error'))
        expect(errors['code']).to eq(Api::V1::BaseController::TOKEN_EXPIRED_CODE.to_s)
      end
    end
  end

  describe 'key transform header' do
    before(:each) do
      FactoryGirl.create(:job, short_description: 'shortdescription')
    end

    context 'with X-API-KEY-TRANSFORM underscore' do
      it 'returns all keys in underscore format' do
        get api_v1_jobs_path, headers: { 'X-API-KEY-TRANSFORM' => 'underscore' }

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')
        expect(short_description).to eq('shortdescription')
      end
    end

    context 'with X-API-KEY-TRANSFORM dash' do
      it 'returns all keys in dashed/kebab-case format' do
        get api_v1_jobs_path, headers: { 'X-API-KEY-TRANSFORM' => 'dash' }

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')

        expect(short_description).to eq('shortdescription')
      end

      it 'returns all keys in dashed/kebab-case format by default' do
        get api_v1_jobs_path

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')

        expect(short_description).to eq('shortdescription')
      end
    end
  end
end
