# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::ResetPasswordController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }

    let(:valid_attributes) do
      {
        data: {
          attributes: {
            email_or_phone: user.email
          }
        }
      }
    end

    let(:invalid_attributes) do
      {
        data: {
          attributes: {
            email_or_phone: 'XXXXYYYYZZZ'
          }
        }
      }
    end

    context 'with valid params' do
      it 'returns 202 accepted status' do
        post :create, params: valid_attributes
        expect(response.status).to eq(202)
      end

      it 'sends reset password email' do
        allow(ResetPasswordNotifier).to receive(:call).with(user: user)
        post :create, params: valid_attributes
        expect(ResetPasswordNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'returns 202 accepted status' do
        post :create, params: invalid_attributes
        expect(response.status).to eq(202)
      end
    end
  end
end
