# frozen_string_literal: true
module Index
  class HourlyPaysIndex < BaseIndex
    ALLOWED_FILTERS = %i(id gross_salary).freeze
    SORTABLE_FIELDS = %i(gross_salary).freeze
    MAX_PER_PAGE = 100

    def hourly_pays(scope = HourlyPay)
      @hourly_pays ||= prepare_records(scope)
    end
  end
end
