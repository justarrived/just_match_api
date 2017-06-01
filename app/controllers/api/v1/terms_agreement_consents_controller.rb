# frozen_string_literal: true

module Api
  module V1
    class TermsAgreementConsentsController < BaseController
      after_action :verify_authorized, except: %i(create)

      resource_description do
        short 'API for terms and agreement consents'
        name 'Terms of agreement consents'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :POST, '/terms-consents', 'Create terms of agreement consent.'
      description 'Creates and returns new terms of agreement consent.'
      error code: 400, desc: 'Bad request'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Terms attributes', required: true do
          param :terms_agreement_id, Integer, desc: 'Terms of agreement id', required: true # rubocop:disable Metrics/LineLength
          param :user_id, Integer, desc: 'User id', required: true
          param :job_id, Integer, desc: 'Job id (required unless the terms agreement is for companies)' # rubocop:disable Metrics/LineLength
        end
      end
      example Doxxer.read_example(TermsAgreementConsent, method: :create)
      def create
        user = User.find_by(id: jsonapi_params[:user_id])
        job = Job.find_by(id: jsonapi_params[:job_id])
        authorize_create(user)

        @terms_consent = TermsAgreementConsent.new.tap do |terms_consent|
          terms_id = jsonapi_params[:terms_agreement_id]

          terms_consent.terms_agreement = TermsAgreement.find_by(id: terms_id)
          terms_consent.user = user
          terms_consent.job = job
        end

        if @terms_consent.save
          api_render(@terms_consent, status: :created)
        else
          api_render_errors(@terms_consent)
        end
      end

      private

      def authorize_create(user)
        raise Pundit::NotAuthorizedError if not_logged_in? || current_user != user
      end
    end
  end
end
