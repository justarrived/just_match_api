# frozen_string_literal: true
# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#

require 'rails_helper'

RSpec.describe Api::V1::Users::DocumentsController, type: :controller do
  describe 'POST #create' do
    let(:category) { Document::CATEGORIES.keys.last }
    let(:valid_params) do
      {
        data: {
          attributes: {
            document: TestDocumentFileReader.document,
            category: category
          }
        }
      }
    end

    let(:invalid_params) do
      {}
    end

    context 'with valid params' do
      it 'saves document' do
        post :create, params: valid_params
        expect(assigns(:document)).to be_persisted
      end

      it 'returns 201 accepted status' do
        post :create, params: valid_params
        expect(response.status).to eq(201)
      end

      it 'assigns the document category' do
        post :create, params: valid_params
        document = assigns(:document)
        expect(document.category).to eq(category.to_s)
      end
    end

    context 'with invalid params' do
      it 'returns 422 accepted status' do
        post :create, params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end
end
