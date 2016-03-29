# frozen_string_literal: true
module Index
  class CategoriesIndex < BaseIndex
    FILTER_MATCH_TYPES = { name: :starts_with }.freeze
    ALLOWED_FILTERS = %i(name).freeze
    SORTABLE_FIELDS = %i(name).freeze
    MAX_PER_PAGE = 100

    def categories(scope = Category)
      @categories ||= prepare_records(scope)
    end
  end
end
