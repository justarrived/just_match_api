# frozen_string_literal: true
module AdminHelper
  def user_profile_image(user:, size: :medium)
    user.user_images.
      where(user: user, category: 'profile').
      first&.image&.url(size)
  end

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
      html_parts = [
        name,
        nbsp_html,
        "(#{proficiency}/#{proficiency_by_admin})"
      ]
      name = safe_join(html_parts, ' ')
    end

    link_to(
      name,
      admin_users_path + AdminHelpers::Link.query(:user_skills_skill_id, skill.id),
      class: 'user-badge-skill-link',
      style: "border-color: #{skill.color}"
    )
  end

  def user_languages_badges(user_languages:)
    links = user_languages.map do |user_language|
      language_badge(language: user_language.language, user_language: user_language)
    end

    safe_join(links, ' ')
  end

  def language_badge(language:, user_language: nil)
    name = language.name
    if user_language
      proficiency = user_language.proficiency || '-'
      proficiency_by_admin = user_language.proficiency_by_admin || '-'
      html_parts = [
        name,
        nbsp_html,
        "(#{proficiency}/#{proficiency_by_admin})"
      ]
      name = safe_join(html_parts, ' ')
    end

    link_to(
      name,
      admin_users_path + AdminHelpers::Link.query(:user_languages_language_id, language.id), # rubocop:disable Metrics/LineLength
      class: 'user-badge-tag-link'
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

  def nbsp_html
    ' &nbsp; '.html_safe # rubocop:disable Rails/OutputSafety
  end
end
