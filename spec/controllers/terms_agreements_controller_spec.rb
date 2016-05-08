# frozen_string_literal: true
# == Schema Information
#
# Table name: terms_agreements
#
#  id         :integer          not null, primary key
#  version    :string
#  url        :string(2000)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_terms_agreements_on_version  (version) UNIQUE
#

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
