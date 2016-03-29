# frozen_string_literal: true
module Index
  class HourlyPaysIndex < BaseIndex
    ALLOWED_FILTERS = %i(rate).freeze
    SORTABLE_FIELDS = %i(rate).freeze
    MAX_PER_PAGE = 100

    def hourly_pays(scope = HourlyPay)
      @hourly_pays ||= prepare_records(scope)
    end
  end
end
