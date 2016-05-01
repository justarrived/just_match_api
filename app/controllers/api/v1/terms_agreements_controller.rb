# frozen_string_literal: true
module Api
  module V1
    class TermsAgreementsController < BaseController
      after_action :verify_authorized, except: %i(current)

      resource_description do
        short 'API for terms and agreements'
        name 'Terms of agreement'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/terms-agreements/current', 'Current terms of agreement'
      description 'Returns the current terms of agreement'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(TermsAgreement)
      def current
        @terms_agreement = TermsAgreement.last

        api_render(@terms_agreement)
      end
    end
  end
end
