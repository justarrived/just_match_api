# frozen_string_literal: true

module SetSkillFiltersService
  def self.call(filter:, skill_ids_param:)
    return SkillFilter.none if skill_ids_param.blank?

    filter_skills_params = normalize_skill_ids(skill_ids_param)
    filter.filter_skills = filter_skills_params.map do |attrs|
      SkillFilter.find_or_initialize_by(filter: filter, skill_id: attrs[:id]).tap do |sf|
        sf.proficiency = attrs[:proficiency] if attrs[:proficiency].present?

        if attrs[:proficiency_by_admin].present?
          sf.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
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
