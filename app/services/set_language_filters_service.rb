# frozen_string_literal: true

module SetLanguageFiltersService
  def self.call(filter:, language_ids_param:)
    return LanguageFilter.none if language_ids_param.blank?

    filter_languages_params = normalize_language_ids(language_ids_param)
    filter.filter_languages = filter_languages_params.map do |attrs|
      LanguageFilter.find_or_initialize_by(filter: filter, language_id: attrs[:id]).
        tap do |lf|
        lf.proficiency = attrs[:proficiency] if attrs[:proficiency].present?

        if attrs[:proficiency_by_admin].present?
          lf.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
  end

  def self.normalize_language_ids(language_ids_param)
    language_ids_param.map do |language|
      if language.respond_to?(:permit)
        language.permit(:id, :proficiency)
      else
        language
      end
    end
  end
end
