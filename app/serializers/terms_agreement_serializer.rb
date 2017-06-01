# frozen_string_literal: true

class TermsAgreementSerializer < ApplicationSerializer
  ATTRIBUTES = %i(version url).freeze
  attributes ATTRIBUTES
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
