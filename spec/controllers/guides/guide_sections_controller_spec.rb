# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Guides::GuideSectionsController, type: :controller do
  describe 'GET #index' do
    it 'returns sections' do
      section = FactoryBot.create(:guide_section)
      get :index
      expect(assigns(:sections)).to eq([section])
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      process :index, method: :get
      expect(response.code).to eq("200")
    end
  end

  describe 'GET #show' do
    it 'returns section' do
      section = FactoryBot.create(:guide_section)
      get :show, params: { section_id: section.id }
      expect(assigns(:section)).to eq(section)
    end

    it 'can find section by slug' do
      section = FactoryBot.create(:guide_section)
      section.set_translation(slug: 'my-test-slug')
      get :show, params: { section_id: section.slug }
      expect(assigns(:section)).to eq(section)
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      section = FactoryBot.create(:guide_section)
      get :show, params: { section_id: section.id }
      expect(response.code).to eq("200")
    end
  end
end
