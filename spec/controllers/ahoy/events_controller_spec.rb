# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Ahoy::EventsController, type: :controller do
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          page_url: 'http://example.com'
        }
      }
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders 204 No Content' do
        post :create, params: valid_attributes
        expect(response.status).to eq(204)
      end

      it 'creates a new Ahoy::Event' do
        expect do
          post :create, params: valid_attributes
        end.to change(Ahoy::Event, :count).by(1)
      end
    end
  end
end
