module Index
  class BaseIndex
    delegate :params, to: :controller
    delegate :policy_scope, to: :controller

    DEFAULT_SORTING = { created_at: :desc }
    SORTABLE_FIELDS = %i(created_at)
    PER_PAGE = 25

    attr_reader :controller

    def initialize(controller)
      @controller = controller
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
