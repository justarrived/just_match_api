# frozen_string_literal: true
module SetUserSkillsService
  def self.call(user:, skill_ids_param:)
    return UserSkill.none if skill_ids_param.nil?

    current_user_skills = user.user_skills
    user_skills_params = normalize_skill_ids(skill_ids_param)
    user_skills = user_skills_params.map do |attrs|
      UserSkill.find_or_initialize_by(user: user, skill_id: attrs[:id]).tap do |us|
        us.proficiency = attrs[:proficiency] unless attrs[:proficiency].blank?

        unless attrs[:proficiency_by_admin].blank?
          us.proficiency_by_admin = attrs[:proficiency_by_admin]
        end
      end
    end
    user_skills.each(&:save)

    # We want to replace all the skills that the user just sent in, but we don't
    # want to delete the skills that an admin has touched
    (current_user_skills - user_skills).each do |user_skill|
      user_skill.destroy if user_skill.proficiency_by_admin.nil?
    end

    user_skills
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
