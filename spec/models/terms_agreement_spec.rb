# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TermsAgreement, type: :model do
  context 'klass' do
    let(:ff_company_term) { FactoryBot.create(:frilans_finans_term, company: true) }
    let(:ff_user_term) { FactoryBot.create(:frilans_finans_term, company: true) }

    describe '#current_user_terms' do
      it 'returns the lastest user terms' do
        FactoryBot.create(:terms_agreement)
        FactoryBot.create(:terms_agreement, frilans_finans_term: ff_company_term)
        terms = FactoryBot.create(:terms_agreement)
        expect(described_class.current_user_terms).to eq(terms)
      end
    end

    describe '#current_company_user_terms' do
      it 'returns the lastest user terms' do
        FactoryBot.create(:terms_agreement)
        FactoryBot.create(:terms_agreement, frilans_finans_term: ff_company_term)
        terms = FactoryBot.create(:terms_agreement, frilans_finans_term: ff_company_term)
        expect(described_class.current_company_user_terms).to eq(terms)
      end
    end
  end

  describe '#validate_url_with_protocol' do
    let(:message) { I18n.t('errors.general.protocol_missing') }

    it 'adds error unless website start with protocol' do
      terms_agreement = FactoryBot.build(:terms_agreement, url: 'example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url]).to include(message)
    end

    it 'adds *no* error if website start with http:// protocol' do
      terms_agreement = FactoryBot.build(:terms_agreement, url: 'http://example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url] || []).not_to include(message)
    end

    it 'adds *no* error if website start with https:// protocol' do
      terms_agreement = FactoryBot.build(:terms_agreement, url: 'https://example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url] || []).not_to include(message)
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
#  fk_rails_...  (frilans_finans_term_id => frilans_finans_terms.id)
#
