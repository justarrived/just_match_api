# frozen_string_literal: true
module Index
  class LanguagesIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at lang_code en_name direction system_language).freeze
    ALLOWED_FILTERS = %i(lang_code en_name direction system_language).freeze

    def languages(scope = Language)
      @languages ||= prepare_records(scope)
    end
  end
end
