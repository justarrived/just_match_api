# frozen_string_literal: true
module SetUserLanguagesService
  def self.call(user:, language_ids_param:)
    return UserLanguage.none if language_ids_param.nil? || language_ids_param.empty?

    user_languages_params = normalize_language_ids(language_ids_param)
    user.user_languages = user_languages_params.map do |attrs|
      UserLanguage.new(language_id: attrs[:id], proficiency: attrs[:proficiency])
    end
  end

  def self.normalize_language_ids(language_ids_param)
    language_ids_param.map do |language|
      if language.respond_to?(:permit)
        language.permit(:id, :proficiency)
      elsif language.is_a?(Hash)
        language
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
