# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserDocumentsController, type: :controller do
  let(:user) { FactoryGirl.create(:admin_user) }
  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    {}
  end

  describe 'POST #create' do
    let(:document) { FactoryGirl.create(:document) }
    let(:valid_params) do
      {
        user_id: user.to_param,
        data: {
          attributes: {
            category: :cv,
            document_one_time_token: document.one_time_token
          }
        }
      }
    end

    it 'creates user document' do
      expect do
        post :create, params: valid_params, session: valid_session
        expect(assigns(:user_document).document).to eq(document)
      end.to change(UserDocument, :count).by(1)
    end
  end
end
