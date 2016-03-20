# frozen_string_literal: true
module Index
  class BaseIndex
    delegate :params, to: :controller
    delegate :policy_scope, to: :controller

    DEFAULT_SORTING = { created_at: :desc }.freeze
    SORTABLE_FIELDS = %i(created_at).freeze
    PER_PAGE = Kaminari.config.default_per_page

    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def prepare_records(records)
      policy_scope(records).
        order(sort_params).
        page(current_page).per(current_size)
    end

    protected

    def current_size
      (params.to_unsafe_h.dig('page', 'size') || PER_PAGE).to_i
    end

    def current_page
      (params.to_unsafe_h.dig('page', 'number') || 1).to_i
    end

    def sort_params
      sortable_fields = self.class::SORTABLE_FIELDS
      default_sorting = self.class::DEFAULT_SORTING
      SortParams.sorted_fields(params[:sort], sortable_fields, default_sorting)
    end
  end
end
