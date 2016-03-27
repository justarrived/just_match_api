# frozen_string_literal: true
module Index
  class CategoriesIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at name).freeze
    MAX_PER_PAGE = 100

    def categories(scope = Category)
      @categories ||= prepare_records(scope)
    end
  end
end
