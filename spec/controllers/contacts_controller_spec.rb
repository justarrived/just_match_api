# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  let(:email) { 'watman@example.com' }
  let(:valid_attributes) do
    {
      data: {
        attributes: { email: email }
      }
    }
  end

  let(:invalid_attributes) do
    {}
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders 204 status' do
        post :create, valid_attributes, {}
        expect(response.status).to eq(204)
      end

      it 'sends email' do
        notifier_params = { email: email, name: nil, body: nil }
        allow(ContactNotifier).to receive(:call).with(notifier_params)
        post :create, valid_attributes, {}
        expect(ContactNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'renders 422 unprocessable entity status' do
        post :create, invalid_attributes, {}
        expect(response.status).to eq(422)
      end
    end
  end
end
