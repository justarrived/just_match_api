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

RSpec.describe Api::V1::TermsAgreementsController, type: :routing do
  describe 'routing' do
    it 'routes to #current' do
      path = '/api/v1/terms-agreements/current'
      expect(get: path).to route_to('api/v1/terms_agreements#current')
    end
  end
end
