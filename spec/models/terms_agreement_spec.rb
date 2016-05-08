# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TermsAgreement, type: :model do
  describe '#validate_url_with_protocol' do
    let(:message) { I18n.t('errors.general.protocol_missing') }

    it 'adds error unless website start with protocol' do
      terms_agreement = FactoryGirl.build(:terms_agreement, url: 'example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url]).to include(message)
    end

    it 'adds *no* error if website start with http:// protocol' do
      terms_agreement = FactoryGirl.build(:terms_agreement, url: 'http://example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url] || []).not_to include(message)
    end

    it 'adds *no* error if website start with https:// protocol' do
      terms_agreement = FactoryGirl.build(:terms_agreement, url: 'https://example.com')
      terms_agreement.validate

      expect(terms_agreement.errors.messages[:url] || []).not_to include(message)
    end
  end
end

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
