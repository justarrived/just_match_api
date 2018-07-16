# frozen_string_literal: true

module Sweepers
  class TermsAgreementSweeper
    def self.destroy_orphans(scope = TermsAgreement)
      scope.over_aged_orphans.delete_all
    end
  end
end
