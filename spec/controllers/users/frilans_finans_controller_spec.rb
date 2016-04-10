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
            account_clearing_nr: 'account_clearing_nr',
            account_nr: 'account_nr'
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

    it 'returns 200 ok' do
      post :create, valid_params, valid_session
      expect(response.status).to eq(200)
    end

    it 'returns empty JSON body' do
      post :create, valid_params, valid_session
      expect(response.body).to eq('{}')
    end

    it 'sets User#frilans_finans_id' do
      post :create, valid_params, valid_session
      expect(assigns(:user).frilans_finans_id).to eq(1)
    end

    context 'frilans_finans_id already set' do
      let(:ff_id) { 10 }
      let(:user) { FactoryGirl.create(:user, frilans_finans_id: ff_id) }

      it 'leaves User#frilans_finans_id unchanged' do
        post :create, valid_params, valid_session
        expect(assigns(:user).frilans_finans_id).to eq(ff_id)
      end

      it 'returns 422 unprocessable entity' do
        post :create, valid_params, valid_session
        expect(response.status).to eq(422)
      end

      it 'returns valid jsonapi errors' do
        post :create, valid_params, valid_session
        result = JSON.parse(response.body)['errors'].first
        message = I18n.t('errors.user.frilans_finans_id')
        expected = { 'status' => 422, 'detail' => message }
        expect(result).to eq(expected)
      end
    end
  end
end
