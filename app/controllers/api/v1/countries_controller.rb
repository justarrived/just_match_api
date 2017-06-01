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
      param 'filter[country_code]', String, 'Filter resource by *country_code* [jsonapi.org spec](http://jsonapi.org/format/#fetching-filtering)'
      example '# Example response
{
  "data": [
    {
      "id": "AF",
      "type": "countries",
      "attributes": {
        "country_code": "AF",
        "name": "Afghanistan",
        "local_name": "افغانستان",
        "language_id": 54,
        "en_name": "Afghanistan",
        "sv_name": "Afghanistan",
        "ar_name": "أفغانستان",
        "fa_name": "افغانستان",
        "ku_name": "Efxanistan",
        "ti_name": "Afghanistan",
        "fa_af_name": "افغانستان",
        "ps_name": "افغانستان",
        "translated_text": {
          "name": "Afghanistan",
          "language_id": 54
        }
      }
    }
  ],
  "meta": {
    "total": 1
  }
}
'
      # rubocop:enable Metrics/LineLength
      def index
        filter = JsonApiFilterParams.build(params[:filter], %i(name country_code))

        countries = CountriesSerializer.serializeble_resource(filter: filter)
        render json: countries
      end
    end
  end
end
