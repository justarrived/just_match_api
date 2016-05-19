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

  describe 'GET #current_company' do
    it 'returns the last terms of agreement' do
      ff_company_term = FactoryGirl.create(:frilans_finans_term, company: true)
      terms = FactoryGirl.create(:terms_agreement, frilans_finans_term: ff_company_term)
      FactoryGirl.create(:terms_agreement)
      get :current_company, {}, {}
      expect(assigns(:terms_agreement)).to eq(terms)
    end
  end
end

# == Schema Information
#
# Table name: terms_agreements
#
#  id                     :integer          not null, primary key
#  version                :string
#  url                    :string(2000)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  frilans_finans_term_id :integer
#
# Indexes
#
#  index_terms_agreements_on_frilans_finans_term_id  (frilans_finans_term_id)
#  index_terms_agreements_on_version                 (version) UNIQUE
#
# Foreign Keys
#
#  fk_rails_d0dcb0c0f5  (frilans_finans_term_id => frilans_finans_terms.id)
#
