# frozen_string_literal: true
module AdminHelper
  def user_tag_badges(user:)
    tag_links = user.tags.map { |tag| user_tag_badge(tag: tag) }
    safe_join(tag_links, ' ')
  end

  def user_tag_badge(tag:)
    link_to(
      tag.name,
      admin_users_path + AdminHelpers::Link.query(:user_tags_tag_id, tag.id),
      class: 'user-badge-tag-link',
      style: "background-color: #{tag.color}"
    )
  end

  def user_skills_badges(user_skills:)
    links = user_skills.map do |user_skill|
      skill_badge(skill: user_skill.skill, user_skill: user_skill)
    end

    safe_join(links, ' ')
  end

  def skills_badges(skills:)
    links = skills.map { |skill| skill_badge(skill: skill) }
    safe_join(links, ' ')
  end

  def skill_badge(skill:, user_skill: nil)
    name = skill.name
    if user_skill
      proficiency = user_skill.proficiency || '-'
      proficiency_by_admin = user_skill.proficiency_by_admin || '-'
      name = "#{name} &nbsp; (#{proficiency}/#{proficiency_by_admin})".html_safe
    end

    link_to(
      name,
      admin_users_path + AdminHelpers::Link.query(:user_skills_skill_id, skill.id),
      class: 'user-badge-skill-link',
      style: "border-color: #{skill.color}"
    )
  end

  def colored_badge_tag(name, color)
    content_tag(
      :span,
      name,
      class: 'user-badge-tag-link',
      style: "background-color: #{color}"
    )
  end
end
