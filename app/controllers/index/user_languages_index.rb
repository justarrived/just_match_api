# frozen_string_literal: true
module Index
  class UserLanguagesIndex < BaseIndex
    ALLOWED_FILTERS = %i(lang_code en_name direction system_language).freeze

    def user_languages(scope = UserLanguage)
      @user_languages ||= prepare_records(scope.includes(:language))
    end
  end
end
