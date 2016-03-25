# frozen_string_literal: true
module Index
  class UserSkillsIndex < BaseIndex
    ALLOWED_INCLUDES = %w(user skill).freeze

    def user_skills(scope = UserSkill)
      @user_skills ||= prepare_records(scope.includes(:skill))
    end
  end
end
