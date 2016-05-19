# frozen_string_literal: true
module Api
  module V1
    class TermsAgreementsController < BaseController
      after_action :verify_authorized, except: %i(current current_company)

      resource_description do
        short 'API for terms and agreements'
        name 'Terms of agreement'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/terms-agreements/current', 'Current terms of agreement for user'
      description 'Returns the current terms of agreement for user'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(TermsAgreement)
      def current
        @terms_agreement = TermsAgreement.current_user_terms

        api_render(@terms_agreement)
      end

      api :GET, '/terms-agreements/current-company', 'Current terms of agreement for company user' # rubocop:disable Metrics/LineLength
      description 'Returns the current terms of agreement for company user'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(TermsAgreement)
      def current_company
        @terms_agreement = TermsAgreement.current_company_user_terms

        api_render(@terms_agreement)
      end
    end
  end
end
