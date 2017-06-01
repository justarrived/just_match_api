# frozen_string_literal: true

module SetJobLanguagesService
  def self.call(job:, language_ids_param:)
    return JobLanguage.none if language_ids_param.nil?

    job_languages_params = normalize_language_ids(language_ids_param)
    job_languages = job_languages_params.map do |attrs|
      JobLanguage.find_or_initialize_by(
        job: job, language_id: attrs[:id]
      ).tap do |job_language|
        job_language.proficiency = attrs[:proficiency] if attrs[:proficiency].present?

        if attrs[:proficiency_by_admin].present?
          job_language.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
    job_languages.each(&:save)
    job_languages
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
