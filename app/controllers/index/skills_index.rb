# frozen_string_literal: true
module Index
  class SkillsIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at name).freeze

    def skills
      @skills ||= prepare_records(Skill)
    end
  end
end
