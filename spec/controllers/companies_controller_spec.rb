# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :controller do
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all companies as @companies' do
      company = FactoryGirl.create(:company)
      get :index, {}, valid_session
      expect(assigns(:companies)).to eq([company])
    end
  end

  describe 'GET #show' do
    it 'assigns company as @company' do
      company = FactoryGirl.create(:company)
      get :show, { id: company.to_param }, valid_session
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'POST #create' do
    let(:frilans_api_klass) { FrilansFinansApi::Company }
    let(:ff_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: 1)) }

    let(:valid_params) do
      {
        data: {
          attributes: {
            name: 'Company name',
            cin: '0000000000',
            website: 'http://www.example.com'
          }
        }
      }
    end

    it 'creates a new Company' do
      expect do
        post :create, valid_params, valid_session
      end.to change(Company, :count).by(1)
    end

    it 'assigns a valid company as @company' do
      get :create, valid_params, {}
      expect(assigns(:company).valid?).to eq(true)
    end

    it 'returns 201 created status' do
      get :create, valid_params, valid_session
      expect(response.status).to eq(201)
    end

    it 'calls company create on frilans finans api' do
      allow(frilans_api_klass).to receive(:create).and_return(ff_document_mock)
      post :create, valid_params, valid_session
      expect(frilans_api_klass).to have_received(:create)
    end
  end
end
