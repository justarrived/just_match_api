# frozen_string_literal: true

module Api
  module V1
    module Ahoy
      class EventsController < BaseController
        after_action :track_request, except: %i[create]

        resource_description do
          short 'API for managing Ahoy events'
          name 'Ahoy events'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        EVENT_TYPES = %w[page_view].freeze

        api :POST, '/ahoy/events/', 'Create new Ahoy event'
        description 'Creates an Ahoy event.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 403, desc: 'Forbidden'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Event attributes', required: true do
            param :type, String, desc: "The event type, one of: #{EVENT_TYPES.to_sentence}" # rubocop:disable Metrics/LineLength
            param :page_url, String, desc: 'Page URL', required: true
          end
        end
        def create
          authorize(::Ahoy::Event)

          unless EVENT_TYPES.include?(jsonapi_params[:type])
            message = "unknown event type must be one of: #{EVENT_TYPES.to_sentence}."
            errors = JsonApiErrors.new
            errors.add(detail: message, attribute: :page_url)

            render json: errors, status: :unprocessable_entity
            return
          end

          create_page_view
        end

        private

        def create_page_view
          page_url = jsonapi_params[:page_url]
          attributes = { page_url: page_url }

          if AbsoluteUrl.valid?(page_url)
            track_event(:page_view, attributes)

            response = JsonApiData.new(
              id: SecureGenerator.uuid,
              type: :ahoy_events,
              attributes: attributes
            )
            render json: response, status: :created
          else
            message = I18n.t('errors.validators.url')
            errors = JsonApiErrors.new
            errors.add(detail: message, attribute: :page_url)

            render json: errors, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
