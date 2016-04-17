# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Admin::CompaniesController, type: :controller do
  describe 'POST #create' do
    let(:frilans_api_klass) { FrilansFinansApi::Company }
    let(:ff_document_mock) { OpenStruct.new(resource: OpenStruct.new(id: 1)) }

    let(:valid_params) do
      {
        company: {
          name: 'A company name',
          cin: '0000000000',
          email: 'company@example.com',
          zip: '11850',
          street: 'Hornsgatan 54',
          city: 'Stockholm',
          country: 'Sweden',
          contact: 'Peter',
          phone: '000000000'
        }
      }
    end

    let(:invalid_params) do
      {
        company: {
          name: 'A company name'
        }
      }
    end

    let(:valid_session) do
      allow_any_instance_of(described_class).to receive(:authenticate_admin).
        and_return(FactoryGirl.build(:admin_user))
      {}
    end

    context 'valid params' do
      it 'responds with 200 status' do
        post :create, valid_params, valid_session
        expect(response.status).to eq(200)
      end

      it 'creates a company' do
        expect do
          post :create, valid_params, valid_session
        end.to change(Company, :count).by(1)
      end

      it 'renders show template' do
        post :create, valid_params, valid_session
        expect(subject).to render_template('show')
      end

      it 'calls company create on frilans finans api' do
        allow(frilans_api_klass).to receive(:create).and_return(ff_document_mock)
        post :create, valid_params, valid_session
        expect(frilans_api_klass).to have_received(:create)
      end
    end

    context 'invalid params' do
      it 'does *not* create a company' do
        expect do
          post :create, invalid_params, valid_session
        end.to change(Company, :count).by(0)
      end

      it 'renders edit template' do
        post :create, invalid_params, valid_session
        expect(subject).to render_template('edit')
      end
    end
  end
end
