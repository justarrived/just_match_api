# frozen_string_literal: true

module Index
  class RatingsIndex < BaseIndex
    SORTABLE_FIELDS = %i(score created_at).freeze
    ALLOWED_FILTERS = %i(job_id score).freeze

    def ratings(scope = Rating)
      @ratings ||= prepare_records(scope)
    end
  end
end
