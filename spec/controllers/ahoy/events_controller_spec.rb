# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Ahoy::EventsController, type: :controller do
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          type: :page_view,
          page_url: 'http://example.com'
        }
      }
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders 204 No Content' do
        post :create, params: valid_attributes
        expect(response.status).to eq(201)
      end

      it 'creates a new Ahoy::Event' do
        expect do
          post :create, params: valid_attributes
        end.to change(Ahoy::Event, :count).by(1)
      end
    end

    context 'with invalid params' do
      context 'bad type' do
        let(:invalid_type_attributes) do
          {
            data: {
              attributes: {
                type: :watman,
                page_url: 'https://example.com'
              }
            }
          }
        end

        it 'does not create a new Ahoy::Event' do
          expect do
            post :create, params: invalid_type_attributes
          end.to change(Ahoy::Event, :count).by(0)
        end

        it 'renders 422 unprocessable entity status' do
          post :create, params: invalid_type_attributes
          expect(response.status).to eq(422)
        end
      end

      context 'bad page URL' do
        let(:invalid_url_attributes) do
          {
            data: {
              attributes: {
                page_url: 'invalid URL'
              }
            }
          }
        end

        it 'does not create a new Ahoy::Event' do
          expect do
            post :create, params: invalid_url_attributes
          end.to change(Ahoy::Event, :count).by(0)
        end

        it 'renders 422 unprocessable entity status' do
          post :create, params: invalid_url_attributes
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
