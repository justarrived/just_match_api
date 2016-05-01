# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class TermsAgreementConsentsController < BaseController
        after_action :verify_authorized, except: %i(create)

        before_action :set_job

        resource_description do
          short 'API for terms and agreement consents'
          name 'Terms of agreement consents'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        api :POST, '/jobs/:job_id/terms-consents', 'Create terms of agreement consent.'
        description 'Creates and returns new terms of agreement consent.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Rating attributes', required: true do
            param :'terms-agreement-id', Integer, desc: 'Terms of agreement id', required: true # rubocop:disable Metrics/LineLength
            param :'user-id', Integer, desc: 'User id', required: true
          end
        end
        example Doxxer.read_example(TermsAgreementConsent, method: :create)
        def create
          user = User.find_by(id: jsonapi_params[:user_id])
          authorize_create(user)

          @terms_consent = TermsAgreementConsent.new.tap do |terms_consent|
            terms_id = jsonapi_params[:terms_agreement_id]

            terms_consent.terms_agreement = TermsAgreement.find_by(id: terms_id)
            terms_consent.user = user
            terms_consent.job = @job
          end

          if @terms_consent.save
            api_render(@terms_consent, status: :created)
          else
            respond_with_errors(@terms_consent)
          end
        end

        private

        def set_job
          @job = Job.find(params[:job_id])
        end

        def authorize_create(user)
          raise Pundit::NotAuthorizedError if not_logged_in? || current_user != user
        end
      end
    end
  end
end
