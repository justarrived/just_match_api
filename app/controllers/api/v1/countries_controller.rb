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
      # rubocop:disable Metrics/LineLength
      param 'filter[name]', String, 'Filter resource by *name* [jsonapi.org spec](http://jsonapi.org/format/#fetching-filtering)'
      example JSON.pretty_generate(CountriesSerializer.serializeble_resource(key_transform: :underscore).to_h)
      # rubocop:enable Metrics/LineLength
      def index
        filter = JsonApiFilterParams.build(params[:filter], %i(name), {})

        countries = CountriesSerializer.serializeble_resource(
          filter: filter,
          key_transform: key_transform_header
        )
        render json: countries
      end
    end
  end
end
