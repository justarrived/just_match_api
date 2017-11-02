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

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :integer          not null, primary key
#  visit_id   :integer
#  user_id    :integer
#  name       :string
#  properties :jsonb
#  time       :datetime
#
# Indexes
#
#  index_ahoy_events_on_name_and_time      (name,time)
#  index_ahoy_events_on_user_id_and_name   (user_id,name)
#  index_ahoy_events_on_visit_id_and_name  (visit_id,name)
#
# Foreign Keys
#
#  ahoy_events_user_id_fk   (user_id => users.id)
#  ahoy_events_visit_id_fk  (visit_id => visits.id)
#
