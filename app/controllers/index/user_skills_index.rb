# frozen_string_literal: true

module Index
  class UserSkillsIndex < BaseIndex
    def user_skills(scope = UserSkill)
      @user_skills ||= prepare_records(scope.includes(:skill))
    end
  end
end
