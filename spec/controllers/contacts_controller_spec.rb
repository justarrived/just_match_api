# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  let(:name) { 'Watman' }
  let(:email) { 'watman@example.com' }
  let(:body) { 'I am watman!' }
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          name: name,
          email: email,
          body: body
        }
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

      it 'creates a new Contact' do
        expect do
          post :create, valid_attributes, {}
        end.to change(Contact, :count).by(1)
      end

      it 'sends email' do
        allow(ContactNotifier).to receive(:call)
        post :create, valid_attributes, {}
        expect(ContactNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Contact' do
        expect do
          post :create, invalid_attributes, {}
        end.to change(Contact, :count).by(0)
      end

      it 'renders 422 unprocessable entity status' do
        post :create, invalid_attributes, {}
        expect(response.status).to eq(422)
      end
    end
  end
end
# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
