# frozen_string_literal: true
module Index
  class JobSkillsIndex < BaseIndex
    def job_skills(scope = JobSkill)
      @job_skills ||= begin
        include_scopes = []
        include_scopes << included?('skill') ? { skill: [:language] } : :skill

        prepare_records(scope.includes(*include_scopes))
      end
    end
  end
end
