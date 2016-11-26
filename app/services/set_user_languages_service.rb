# frozen_string_literal: true
module SetUserLanguagesService
  def self.call(user:, language_ids_param:)
    return [] if language_ids_param.nil?
    user_languages_params = normalize_language_ids(language_ids_param)
    return [] if user_languages_params.empty?

    user.user_languages = user_languages_params.map do |attrs|
      UserLanguage.new(language_id: attrs[:id], proficiency: attrs[:proficiency])
    end
  end

  def self.normalize_language_ids(language_ids_param)
    language_ids_param.map do |language|
      if language.is_a?(ActionController::Parameters) || language.is_a?(Hash)
        language.permit(:id, :proficiency)
      else
        message = [
          'Passing languages as a list of integers is deprecated.',
          'Please pass an array of objects, i.e [{ id: 1, proficiency: 1 }]'
        ].join(' ')
        ActiveSupport::Deprecation.warn(message)

        { id: language, proficiency: nil }
      end
    end
  end
end
