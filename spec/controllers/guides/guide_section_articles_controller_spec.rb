# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Guides::GuideSectionArticlesController, type: :controller do
  describe 'GET #index' do
    it 'returns articles' do
      article = FactoryBot.create(:guide_section_article)
      get :index, params: { section_id: article.section.id }
      expect(assigns(:articles)).to eq([article])
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      article = FactoryBot.create(:guide_section_article)
      get :index, params: { section_id: article.section.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'returns article' do
      article = FactoryBot.create(:guide_section_article)
      get :show, params: { section_id: article.section.id, article_id: article.id }
      expect(assigns(:article)).to eq(article)
    end

    it 'can find article by slug' do
      article = FactoryBot.create(:guide_section_article)
      article.set_translation(slug: 'my-test-slug')

      params = {
        section_id: article.section.id,
        article_id: article.slug
      }
      get :show, params: params

      expect(assigns(:article)).to eq(article)
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      article = FactoryBot.create(:guide_section_article)
      get :show, params: { section_id: article.section.id, article_id: article.id }

      expect(response.status).to eq(200)
    end
  end
end
