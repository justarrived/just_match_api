# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrilansFinansTerm, type: :model do
  context 'klass' do
    describe '#current_user_terms' do
      it 'returns the lastest user terms' do
        FactoryBot.create(:frilans_finans_term)
        FactoryBot.create(:frilans_finans_term, company: true)
        terms = FactoryBot.create(:frilans_finans_term)
        expect(described_class.current_user_terms).to eq(terms)
      end
    end

    describe '#current_company_user_terms' do
      it 'returns the lastest user terms' do
        FactoryBot.create(:frilans_finans_term)
        FactoryBot.create(:frilans_finans_term, company: true)
        terms = FactoryBot.create(:frilans_finans_term, company: true)
        expect(described_class.current_company_user_terms).to eq(terms)
      end
    end
  end
end

# == Schema Information
#
# Table name: frilans_finans_terms
#
#  id         :integer          not null, primary key
#  body       :text
#  company    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
