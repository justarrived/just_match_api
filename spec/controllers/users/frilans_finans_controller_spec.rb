# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::FrilansFinansController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:valid_params) do
      {
        user_id: user.to_param,
        data: {
          attributes: {
            account_clearing_number: 'account_clearing_number',
            account_number: 'account_number'
          }
        }
      }
    end

    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:authenticate_user_token!).
        and_return(user))
      {}
    end

    context 'valid params' do
      before(:each) do
        stub_frilans_finans_auth_request
        stub_request(:post, "#{FrilansFinansApi.base_uri}/users").
          with(body: /^*/, headers: frilans_finans_authed_request_headers).
          to_return(status: 200, body: '{}', headers: {})
      end

      it 'returns 200 ok' do
        post :create, valid_params, valid_session
        expect(response.status).to eq(200)
      end

      it 'returns empty JSON body' do
        post :create, valid_params, valid_session
        expect(response.body).to eq('{}')
      end

      it 'sets User#frilans_finans_id' do
        isolate_frilans_finans_client(FrilansFinansApi::FixtureClient) do
          post :create, valid_params, valid_session
          expect(assigns(:user).frilans_finans_id).to eq(1)
        end
      end

      it 'sets User#frilans_finans_payment_details' do
        post :create, valid_params, valid_session
        expect(assigns(:user).frilans_finans_payment_details).to eq(true)
      end

      context 'frilans_finans_id already set' do
        before(:each) do
          stub_frilans_finans_auth_request
          stub_request(:patch, "#{FrilansFinansApi.base_uri}/users/10").
            with(body: /^*/, headers: frilans_finans_authed_request_headers).
            to_return(status: 200, body: '{}', headers: {})
        end

        let(:ff_id) { 10 }
        let(:user) { FactoryGirl.create(:user, frilans_finans_id: ff_id) }

        it 'leaves User#frilans_finans_id unchanged' do
          post :create, valid_params, valid_session
          expect(assigns(:user).frilans_finans_id).to eq(ff_id)
        end

        it 'sets User#frilans_finans_payment_details' do
          post :create, valid_params, valid_session
          expect(assigns(:user).frilans_finans_payment_details).to eq(true)
        end

        it 'returns 200 ok status' do
          post :create, valid_params, valid_session
          expect(response.status).to eq(200)
        end
      end
    end

    context 'invalid params' do
      let(:invalid_params) do
        {
          user_id: user.to_param,
          data: {
            attributes: {}
          }
        }
      end

      it 'returns valid jsonapi errors' do
        post :create, invalid_params, valid_session
        result = JSON.parse(response.body)['errors'].first
        expected = {
          'status' => 422,
          'detail' => I18n.t('errors.messages.blank'),
          'source' => {
            'pointer' => '/data/attributes/account-clearing-number'
          }
        }
        expect(result).to eq(expected)
      end
    end
  end
end
