# frozen_string_literal: true
module Index
  class UserLanguagesIndex < BaseIndex
    ALLOWED_INCLUDES = %w(user language).freeze

    def user_languages(scope = UserLanguage)
      @user_languages ||= prepare_records(scope.includes(:language))
    end
  end
end
