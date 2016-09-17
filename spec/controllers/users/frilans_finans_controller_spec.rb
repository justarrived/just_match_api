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
            account_number: 'account_number',
            iban: 'SE35 5000 0000 0549 1000 0003  ',
            bic: 'SWEDSESS'
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
          expect(assigns(:user).frilans_finans_id).not_to be_nil
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

    context 'empty params' do
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
        errors = JSON.parse(response.body)['errors']
        expected = [{
          'status' => 422,
          'detail' => I18n.t('errors.messages.blank'),
          'source' => {
            'pointer' => '/data/attributes/account-clearing-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.messages.blank'),
          'source' => {
            'pointer' => '/data/attributes/account-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.too_short'),
          'source' => {
            'pointer' => '/data/attributes/account-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.unknown_clearing_number'),
          'source' => {
            'pointer' => '/data/attributes/account-clearing-number'
          }
        }]
        expect(errors).to eq(expected)
      end
    end

    context 'incomplete local bank params' do
      let(:invalid_params) do
        {
          user_id: user.to_param,
          data: {
            attributes: {
              account_clearing_number: 'Watman'
            }
          }
        }
      end

      it 'returns valid jsonapi errors' do
        post :create, invalid_params, valid_session
        errors = JSON.parse(response.body)['errors']
        expected = [{
          'status' => 422,
          'detail' => I18n.t('errors.messages.blank'),
          'source' => {
            'pointer' => '/data/attributes/account-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.too_short'),
          'source' => {
            'pointer' => '/data/attributes/account-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.invalid_characters'),
          'source' => {
            'pointer' => '/data/attributes/account-number'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.unknown_clearing_number'),
          'source' => {
            'pointer' => '/data/attributes/account-clearing-number'
          }
        }]
        expect(errors).to eq(expected)
      end
    end

    context 'incomplete foreign bank params' do
      let(:invalid_params) do
        {
          user_id: user.to_param,
          data: {
            attributes: {
              iban: 'Watman'
            }
          }
        }
      end

      it 'returns valid jsonapi errors' do
        post :create, invalid_params, valid_session
        errors = JSON.parse(response.body)['errors']
        expected = [{
          'status' => 422,
          'detail' => I18n.t('errors.messages.blank'),
          'source' => {
            'pointer' => '/data/attributes/bic'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.iban.unknown_country_code'),
          'source' => {
            'pointer' => '/data/attributes/iban'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.iban.bad_check_digits'),
          'source' => {
            'pointer' => '/data/attributes/iban'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.iban.bad_format'),
          'source' => {
            'pointer' => '/data/attributes/iban'
          }
        }, {
          'status' => 422,
          'detail' => I18n.t('errors.bank_account.bic.bad_format'),
          'source' => {
            'pointer' => '/data/attributes/bic'
          }
        }]
        expect(errors).to eq(expected)
      end
    end
  end
end
