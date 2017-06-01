# frozen_string_literal: true

module SetJobSkillsService
  def self.call(job:, skill_ids_param:)
    return JobSkill.none if skill_ids_param.nil?

    job_skills_params = normalize_skill_ids(skill_ids_param)
    job_skills = job_skills_params.map do |attrs|
      JobSkill.find_or_initialize_by(job: job, skill_id: attrs[:id]).tap do |job_skill|
        job_skill.proficiency = attrs[:proficiency] if attrs[:proficiency].present?

        if attrs[:proficiency_by_admin].present?
          job_skill.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
    job_skills.each(&:save)
    job_skills
  end

  def self.normalize_skill_ids(skill_ids_param)
    skill_ids_param.map do |skill|
      if skill.respond_to?(:permit)
        skill.permit(:id, :proficiency)
      else
        skill
      end
    end
  end
end
