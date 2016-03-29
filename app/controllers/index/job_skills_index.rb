# frozen_string_literal: true
module Index
  class JobSkillsIndex < BaseIndex
    def job_skills(scope = JobSkill)
      @job_skills ||= begin
        include_scopes = []

        include_scopes << if included?('skill')
                            { skill: [:language] }
                          else
                            :skill
                          end

        prepare_records(scope.includes(*include_scopes))
      end
    end
  end
end
