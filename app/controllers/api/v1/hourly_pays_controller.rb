# frozen_string_literal: true
module Api
  module V1
    class HourlyPaysController < BaseController
      resource_description do
        short 'API for hourly pays'
        name 'Hourly Pays'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/hourly-pays', 'List hourly pays'
      description 'Returns a list of hourly pays.'
      ApipieDocHelper.params(self, Index::HourlyPaysIndex)
      example Doxxer.read_example(HourlyPay, plural: true)
      def index
        authorize(HourlyPay)

        hourly_pays_index = Index::HourlyPaysIndex.new(self)
        @hourly_pays = hourly_pays_index.hourly_pays

        api_render(@hourly_pays)
      end
    end
  end
end
