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

        api :POST, '/ahoy/events/', 'Create new Ahoy event'
        description 'Creates an Ahoy event.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 403, desc: 'Forbidden'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Event attributes', required: true do
            param :page_url, String, desc: 'Page URL', required: true
          end
        end
        def create
          authorize(::Ahoy::Event)

          track_event(:page_view, page_url: jsonapi_params[:page_url])

          head :no_content
        end
      end
    end
  end
end
