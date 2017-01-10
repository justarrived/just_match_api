# frozen_string_literal: true
module Index
  class SkillsIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at name).freeze
    MAX_PER_PAGE = 100

    def skills(scope = Skill)
      @skills ||= prepare_records(scope.with_translations)
    end
  end
end
