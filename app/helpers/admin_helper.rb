# frozen_string_literal: true
module AdminHelper
  def safe_pretty_print_json(json_string)
    content_tag :pre, begin
      hash = JSON.parse(json_string)
      JSON.pretty_generate(hash)
    rescue JSON::ParserError => _e
      json_string
    end
  end

  def datetime_ago_in_words(datetime)
    created_at = datetime.strftime('%A at %H:%M, %B %d, %Y')
    time_ago_in_words = distance_of_time_in_words(Time.zone.now, datetime)
    "#{time_ago_in_words} ago on #{created_at}"
  end

  def download_link_to(url:, file_name:, title: I18n.t('admin.download'))
    link_to(title, url, download: file_name)
  end

  def european_date(datetime)
    datetime.strftime('%Y-%m-%d')
  end

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
    simple_link_badge_tag(
      tag.name,
      admin_users_path + AdminHelpers::Link.query(:user_tags_tag_id, tag.id),
      color: tag.color
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

  def job_skills_badges(job_skills:)
    links = job_skills.map do |job_skill|
      job_skill_badge(skill: job_skill.skill, job_skill: job_skill)
    end

    safe_join(links, ' ')
  end

  def job_skill_badge(skill:, job_skill: nil)
    path = AdminHelpers::Link.query(:job_skills_skill_id, skill.id)
    simple_link_badge_tag(
      skill.name,
      admin_users_path + path,
      color: skill.color,
      value: job_skill&.proficiency,
      value_by_admin: job_skill&.proficiency_by_admin
    )
  end

  def skill_badge(skill:, user_skill: nil)
    path = AdminHelpers::Link.query(:user_skills_skill_id, skill.id)
    simple_link_badge_tag(
      skill.name,
      admin_users_path + path,
      color: skill.color,
      value: user_skill&.proficiency,
      value_by_admin: user_skill&.proficiency_by_admin
    )
  end

  def user_languages_badges(user_languages:)
    links = user_languages.map do |user_language|
      language_badge(language: user_language.language, user_language: user_language)
    end

    safe_join(links, ' ')
  end

  def language_badge(language:, user_language: nil)
    path = AdminHelpers::Link.query(:user_languages_language_id, language.id)
    simple_link_badge_tag(
      language.name,
      admin_users_path + path,
      value: user_language&.proficiency,
      value_by_admin: user_language&.proficiency_by_admin
    )
  end

  def user_interests_badges(user_interests:)
    links = user_interests.map do |user_interest|
      interest_badge(interest: user_interest.interest, user_interest: user_interest)
    end

    safe_join(links, ' ')
  end

  def interest_badge(interest:, user_interest: nil)
    path = AdminHelpers::Link.query(:user_interests_interest_id, interest.id)
    simple_link_badge_tag(
      interest.name,
      admin_users_path + path,
      value: user_interest&.level,
      value_by_admin: user_interest&.level_by_admin
    )
  end

  def simple_link_badge_tag(name, link_to_path, color: '#e7e7e7', value: nil, value_by_admin: nil) # rubocop:disable Metrics/LineLength
    full_name = name
    if value || value_by_admin
      html_parts = [
        name,
        nbsp_html,
        "(#{value || '-'}/#{value_by_admin || '-'})"
      ]
      full_name = safe_join(html_parts, ' ')
    end

    link_to(
      full_name,
      link_to_path,
      class: 'user-badge-tag-link',
      style: "border-color: #{color}"
    )
  end

  def simple_badge_tag(name, color: nil)
    options = { class: 'user-badge-tag-link' }
    options[:style] = "background-color: #{color}" if color

    content_tag(:span, name, options)
  end

  def nbsp_html
    ' &nbsp; '.html_safe # rubocop:disable Rails/OutputSafety
  end
end
