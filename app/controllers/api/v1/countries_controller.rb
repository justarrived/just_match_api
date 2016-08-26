# frozen_string_literal: true
module Api
  module V1
    class CountriesController < BaseController
      after_action :verify_authorized, except: [:index]

      resource_description do
        short 'API for countries'
        name 'Countries'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/countries', 'List countries'
      description 'Returns a list of countries'
      example "# Example response
#{JSON.pretty_generate(CountriesSerializer.serializeble_resource.to_h)}"
      def index
        filter = JsonApiFilterParams.build(params[:filter], %i(name), {})

        render json: CountriesSerializer.serializeble_resource(filter: filter)
      end
    end
  end
end
