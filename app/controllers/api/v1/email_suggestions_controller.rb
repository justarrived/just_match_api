# frozen_string_literal: true

require 'email_suggestion'

module Api
  module V1
    class EmailSuggestionsController < BaseController
      after_action :verify_authorized, except: [:suggest]

      resource_description do
        short 'API for email suggestions'
        name 'Email suggestions'
        description 'Here you can get suggestions for misspelled domains for common proivders' # rubocop:disable Metrics/LineLength
        formats [:json]
        api_versions '1.0'
      end

      api :POST, '/email-suggestion', 'Suggest email'
      description 'Returns suggestions for common misstakes when inputting an email address.' # rubocop:disable Metrics/LineLength
      error code: 400, desc: 'Bad request'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Attributes', required: true do
          param :email, String, desc: 'Email address', required: true
        end
      end
      example <<~JSON_EXAMPLE
        # Response example
        #{JSON.pretty_generate(JsonApiData.new(
          id: SecureGenerator.token(length: 32),
          type: :email_suggestions,
          attributes: {
            address: 'buren',
            domain: 'example.com',
            full: 'buren@example.com'
          }
        ).to_h)}
      JSON_EXAMPLE
      def suggest
        attributes = {}

        email = jsonapi_params[:email]
        if email.present?
          suggestion = EmailSuggestion.call(email)
          attributes = suggestion unless suggestion.empty?
        end

        response = JsonApiData.new(
          id: SecureGenerator.token(length: 32),
          type: :email_suggestions,
          attributes: attributes
        )

        render json: response, status: :ok
      end
    end
  end
end
