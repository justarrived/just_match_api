# frozen_string_literal: true
module Index
  class LanguagesIndex < BaseIndex
    MAX_PER_PAGE = 300
    LOCALE_FIELD_NAMES = %i(
      en_name sv_name ar_name fa_name fa_af_name ku_name ti_name ps_name
    ).freeze
    FILTER_MATCH_TYPES = {
      name: :starts_with,
      en_name: :starts_with,
      sv_name: :starts_with,
      ar_name: :starts_with,
      fa_name: :starts_with,
      fa_af_name: :starts_with,
      ku_name: :starts_with,
      ti_name: :starts_with,
      ps_name: :starts_with
    }.freeze
    SORTABLE_FIELDS = (%i(
      created_at lang_code direction system_language
    ) + LOCALE_FIELD_NAMES).freeze
    ALLOWED_FILTERS = (%i(
      lang_code direction system_language name
    ) + LOCALE_FIELD_NAMES).freeze

    def languages(scope = Language)
      @languages ||= begin
        query = filter_params.delete(:name)
        scope = filter_languages(scope, query) if query
        prepare_records(scope)
      end
    end

    def filter_languages(scope, query)
      search_scope = Language.none
      LOCALE_FIELD_NAMES.each do |field_name|
        language_scope = scope.where(
          "lower(#{field_name}) LIKE lower(concat(?, '%'))", query
        )
        search_scope = search_scope.or(language_scope)
      end
      search_scope
    end
  end
end
