# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class TermsAgreementSeed < BaseSeed
    def self.call(frilans_finans_terms:)
      max_terms_agreement = max_count_opt('MAX_TERMS_AGREEMENTS_SEED', 3)

      log_seed(TermsAgreement) do
        max_terms_agreement.times do |n|
          TermsAgreement.create(
            version: SecureGenerator.token,
            frilans_finans_term: frilans_finans_terms.sample,
            url: 'https://example.com/terms'
          )
        end
      end
    end
  end
end
