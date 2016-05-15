# frozen_string_literal: true
module Index
  class BaseIndex
    delegate :params, to: :controller
    delegate :policy_scope, to: :controller
    delegate :included_resources, to: :controller
    delegate :included_resource?, to: :controller

    DEFAULT_SORTING = { created_at: :desc }.freeze
    SORTABLE_FIELDS = %i(created_at).freeze
    PER_PAGE = Kaminari.config.default_per_page
    MAX_PER_PAGE = Kaminari.config.max_per_page
    ALLOWED_INCLUDES = [].freeze
    FILTER_MATCH_TYPES = {}.freeze
    TRANSFORMABLE_FILTERS = { created_at: :date_range }.freeze
    ALLOWED_FILTERS = %i(created_at).freeze

    attr_reader :controller, :count

    def initialize(controller)
      @controller = controller
      @count = nil
    end

    def prepare_records(records)
      base_records(records).page(current_page).per(current_size)
    end

    protected

    def user_include_scopes(user_key: :user)
      extra_includes = if included_resource?(user_key)
                         %i(language languages company)
                       else
                         []
                       end

      { user_key => extra_includes }
    end

    def base_records(records)
      filtered_records = policy_scope(records)
      filtered_records = filter_records(filtered_records).order(sort_params)
      @count = filtered_records.count
      filtered_records
    end

    def current_size
      page_size = SafeDig.dig(params.to_unsafe_h, 'page', 'size')
      per_page = (page_size || PER_PAGE).to_i
      [per_page, self.class::MAX_PER_PAGE].min
    end

    def current_page
      page_number = SafeDig.dig(params.to_unsafe_h, 'page', 'number')
      (page_number || 1).to_i
    end

    def filter_records(records)
      Queries::Filter.filter(records, filter_params, self.class::FILTER_MATCH_TYPES)
    end

    def sort_params
      sortable_fields = self.class::SORTABLE_FIELDS
      default_sorting = self.class::DEFAULT_SORTING
      SortParams.sorted_fields(params[:sort], sortable_fields, default_sorting)
    end

    def filter_params
      filterable_fields = self.class::ALLOWED_FILTERS
      transformable = self.class::TRANSFORMABLE_FILTERS
      FilterParams.filtered_fields(params[:filter], filterable_fields, transformable)
    end
  end
end
