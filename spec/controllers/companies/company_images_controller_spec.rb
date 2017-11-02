# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Companies::CompanyImagesController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            image: TestImageFileReader.image
          }
        }
      }
    end

    let(:invalid_attributes) do
      {}
    end

    context 'with valid params' do
      it 'saves user image' do
        post :create, params: valid_attributes
        expect(assigns(:company_image)).to be_persisted
      end

      it 'returns 201 accepted status' do
        post :create, params: valid_attributes
        assigns(:company_image)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'returns 422 accepted status' do
        post :create, params: invalid_attributes
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #show' do
    let(:company) { FactoryBot.create(:company) }
    let(:company_image) { FactoryBot.create(:company_image, company: company) }

    it 'returns user image' do
      params = { company_id: company.to_param, id: company_image.to_param }
      get :show, params: params
      expect(assigns(:company_image)).to eq(company_image)
    end

    it 'returns 200 ok status' do
      params = { company_id: company.to_param, id: company_image.to_param }
      get :show, params: params
      assigns(:company_image)
      expect(response.status).to eq(200)
    end
  end
end
