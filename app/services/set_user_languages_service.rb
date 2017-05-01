# frozen_string_literal: true
module SetUserLanguagesService
  def self.call(user:, language_ids_param:)
    return UserLanguage.none if language_ids_param.nil?

    current_user_languages = user.user_languages
    user_languages_params = normalize_language_ids(language_ids_param)
    user_languages = user_languages_params.map do |attrs|
      UserLanguage.find_or_initialize_by(user: user, language_id: attrs[:id]).tap do |ul|
        ul.proficiency = attrs[:proficiency] unless attrs[:proficiency].blank?

        unless attrs[:proficiency_by_admin].blank?
          ul.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
    user_languages.each(&:save)

    # We want to replace all the languages that the user just sent in, but we don't
    # want to delete the languages that an admin has touched
    (current_user_languages - user_languages).each do |user_language|
      user_language.destroy if user_language.proficiency_by_admin.nil?
    end

    user_languages
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
