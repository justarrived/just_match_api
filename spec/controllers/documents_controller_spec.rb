# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DocumentsController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) do
      {
        data: {
          attributes: {
            document: TestDocumentFileReader.document
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
    end

    context 'with invalid params' do
      it 'returns 422 accepted status' do
        post :create, params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end
end

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
#  text_content              :text
#
