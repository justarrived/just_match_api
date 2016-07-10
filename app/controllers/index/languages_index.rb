# frozen_string_literal: true
module Index
  class LanguagesIndex < BaseIndex
    MAX_PER_PAGE = 300
    FILTER_MATCH_TYPES = { en_name: :starts_with }.freeze
    SORTABLE_FIELDS = %i(
      created_at lang_code direction system_language en_name sv_name ar_name fa_name
      fa_af_name ku_name ti_name ps_name
    ).freeze
    ALLOWED_FILTERS = %i(lang_code en_name direction system_language).freeze

    def languages(scope = Language)
      @languages ||= prepare_records(scope)
    end
  end
end
