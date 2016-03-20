# frozen_string_literal: true
module Index
  class LanguagesIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at lang_code).freeze

    def languages
      @languages ||= prepare_records(Language)
    end
  end
end
