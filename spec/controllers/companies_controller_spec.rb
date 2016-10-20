# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :controller do
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all companies as @companies' do
      company = FactoryGirl.create(:company)
      process :index, method: :get, headers: valid_session
      expect(assigns(:companies)).to eq([company])
    end
  end

  describe 'GET #show' do
    it 'assigns company as @company' do
      company = FactoryGirl.create(:company)
      get :show, params: { company_id: company.to_param }, headers: valid_session
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        data: {
          attributes: {
            name: 'Company name',
            cin: '0000000000',
            website: 'http://www.example.com',
            email: 'test@example.com',
            street: 'A street',
            zip: '11851',
            city: 'Stockholm'
          }
        }
      }
    end

    it 'creates a new Company' do
      expect do
        post :create, params: valid_params, headers: valid_session
      end.to change(Company, :count).by(1)
    end

    it 'assigns a valid company as @company' do
      get :create, params: valid_params
      expect(assigns(:company).valid?).to eq(true)
    end

    it 'returns 201 created status' do
      get :create, params: valid_params, headers: valid_session
      expect(response.status).to eq(201)
    end

    context 'company image' do
      let(:company_image) { FactoryGirl.create(:company_image) }

      it 'can add company image' do
        token = company_image.one_time_token

        valid_params[:data][:attributes][:company_image_one_time_token] = token

        post :create, params: valid_params
        expect(assigns(:company).company_images.first).to eq(company_image)
      end

      it 'does not create company image if invalid one time token' do
        valid_params[:data][:attributes][:company_image_one_time_token] = 'token'

        post :create, params: valid_params
        expect(assigns(:company).company_images.first).to be_nil
      end
    end
  end
end

# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  name              :string
#  cin               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  website           :string
#  email             :string
#  street            :string
#  zip               :string
#  city              :string
#  phone             :string
#  billing_email     :string
#
# Indexes
#
#  index_companies_on_cin                (cin) UNIQUE
#  index_companies_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#
