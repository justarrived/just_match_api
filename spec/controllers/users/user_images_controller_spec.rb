# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserImagesController, type: :controller do
  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user_image) { FactoryGirl.create(:user_image, user: user) }
    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(user))
      {}
    end

    it 'returns user image' do
      get :show, params: { user_id: user.to_param, id: user_image.to_param }, headers: valid_session # rubocop:disable Metrics/LineLength
      expect(assigns(:user_image)).to eq(user_image)
    end

    it 'returns 200 ok status' do
      get :show, params: { user_id: user.to_param, id: user_image.to_param }, headers: valid_session # rubocop:disable Metrics/LineLength
      assigns(:user_image)
      expect(response.status).to eq(200)
    end
  end
end
