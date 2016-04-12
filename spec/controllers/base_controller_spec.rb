# frozen_string_literal: true
require 'rails_helper'

# Even though this describes SkillsController, it should really be BaseController tests
RSpec.describe Api::V1::SkillsController, type: :controller do
  context 'locale' do
    after(:each) do
      I18n.locale = I18n.default_locale
    end

    it 'can set the locale from header' do
      request.headers['X-API-LOCALE'] = 'sv'
      get :index, {}, {}
      expect(I18n.locale).to eq(:sv)
    end
  end
end
