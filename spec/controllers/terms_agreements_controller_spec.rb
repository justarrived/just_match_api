# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementsController, type: :controller do
  describe 'GET #current' do
    it 'returns the last terms of agreement' do
      FactoryGirl.create(:terms_agreement)
      terms = FactoryGirl.create(:terms_agreement)
      get :current, {}, {}
      expect(assigns(:terms_agreement)).to eq(terms)
    end
  end
end
