# frozen_string_literal: true

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

require 'rails_helper'

RSpec.describe Api::V1::TermsAgreementsController, type: :routing do
  describe 'routing' do
    it 'routes to #current' do
      path = '/api/v1/terms-agreements/current'
      expect(get: path).to route_to('api/v1/terms_agreements#current')
    end

    it 'routes to #current_company' do
      path = '/api/v1/terms-agreements/current-company'
      expect(get: path).to route_to('api/v1/terms_agreements#current_company')
    end
  end
end
