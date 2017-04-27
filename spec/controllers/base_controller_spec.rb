# frozen_string_literal: true
require 'rails_helper'

# Even though this describes SkillsController, it should really be BaseController tests
RSpec.describe Api::V1::SkillsController, type: :controller do
  context 'locale' do
    after(:each) do
      I18n.locale = I18n.default_locale
    end

    it 'sets the locale from header' do
      request.headers['X-API-LOCALE'] = 'sv'
      get :index
      expect(I18n.locale).to eq(:sv)
    end
  end

  context 'record not found' do
    let(:non_existing_record) { 123_456_768 }

    it 'returns JSONAPI errors' do
      get :show, params: { id: non_existing_record }
      jsonapi_error = JSON.parse(response.body)
      expected = {
        'errors' => [{
          'status' => 404,
          'code' => 'not_found',
          'detail' => I18n.t('record_not_found')
        }]
      }
      expect(jsonapi_error).to eq(expected)
    end
  end
end
