# frozen_string_literal: true
module Api
  module V1
    class HourlyPaysController < BaseController
      before_action :require_promo_code, except: [:index, :calculate]

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

        api_render(@hourly_pays, total: hourly_pays_index.count)
      end

      api :GET, '/hourly-pays/:id', 'Show hourly pays'
      description 'Returns hourly pay.'
      example Doxxer.read_example(HourlyPay)
      def show
        authorize(HourlyPay)

        @hourly_pay = policy_scope(HourlyPay).find(params[:id])

        api_render(@hourly_pay)
      end

      api :GET, '/hourly-pays/calculate', 'Calculate hourly pays'
      description 'Returns a list of hourly pays.'
      param :gross_salary, Float, desc: 'Gross salary', required: true
      example Doxxer.read_example(HourlyPay)
      def calculate
        authorize(HourlyPay)

        hourly_pay = HourlyPay.new(gross_salary: params[:gross_salary].to_i)

        api_render(hourly_pay)
      end
    end
  end
end
