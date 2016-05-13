# frozen_string_literal: true
module Index
  class LanguagesIndex < BaseIndex
    FILTER_MATCH_TYPES = { en_name: :starts_with }.freeze
    SORTABLE_FIELDS = %i(created_at lang_code en_name direction system_language).freeze
    ALLOWED_FILTERS = %i(lang_code en_name direction system_language).freeze

    def languages(scope = Language)
      @languages ||= prepare_records(scope)
    end
  end
end
