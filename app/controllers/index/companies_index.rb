# frozen_string_literal: true
module Index
  class CompaniesIndex < BaseIndex
    FILTER_MATCH_TYPES = { name: :starts_with }.freeze
    ALLOWED_FILTERS = %i(name cin).freeze
    SORTABLE_FIELDS = %i(name created_at).freeze
    MAX_PER_PAGE = 50

    def companies(scope = Company)
      @companies ||= prepare_records(scope)
    end
  end
end
