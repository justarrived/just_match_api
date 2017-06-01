# frozen_string_literal: true

module Sweepers
  class FrilansFinansTermSweeper
    def self.create_frilans_finans
      create_term(type: :user, url: FrilansFinansApi::Terms::USER_URL)
      create_term(type: :company, url: FrilansFinansApi::Terms::COMPANY_USER_URL)
    end

    def self.create_term(type:, url:)
      terms_text = FrilansFinansApi::Terms.get(type: type)
      ff_terms = FrilansFinansTerm.create!(body: terms_text, company: type == :company)

      TermsAgreement.create!(
        version: SecureGenerator.token,
        url: url,
        frilans_finans_term: ff_terms
      )
    end
  end
end
