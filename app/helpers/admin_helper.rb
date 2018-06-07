# frozen_string_literal: true

module AdminHelper
  def render_or_link_document(document)
    if document&.pdf?
      content_tag(:canvas, nil, id: 'pdf-document', 'data-url': document.url)
    elsif document
      download_link_to(url: document.url, file_name: document.document_file_name)
    end
  end

  def safe_pretty_print_json(json_string)
    content_tag :pre, begin
      hash = JSON.parse(json_string)
      JSON.pretty_generate(hash)
    rescue JSON::ParserError => _e
      json_string
    end
  end

  def total_filled_over_sold_order_value(order_value)
    return '-% (-/-)' if order_value.nil?

    total_sold = order_value.sold_total_value
    total_filled = order_value.filled_total_value
    percentage = order_value.filled_percentage(round: 1)

    "#{percentage || '-'}% (#{total_filled || '-'}/#{total_sold || '-'})"
  end

  def user_applications_path(user)
    admin_job_users_path + AdminHelpers::Link.query(:user_id, user.id)
  end

  def link_to_job_preview(job, utm_medium: nil)
    base_url = FrontendRouter.draw(
      :job,
      id: job.id,
      utm_medium: utm_medium || UTM_ADMIN_MEDIUM,
      utm_campaign: 'job_preview',
      utm_content: "job-#{job.id}"
    )

    preview_url = [
      base_url,
      "preview_key=#{job.preview_key}"
    ].join('&')

    preview_url
  end

  def markdown_to_html(markdown)
    ::StringFormatter.new.to_html(markdown)&.html_safe # rubocop:disable Rails/OutputSafety, Metrics/LineLength
  end

  def job_user_current_status_badge(status)
    color = '#323537' # black
    font_weight = 'normal'

    if ['Not pre-reported!', 'Not signed by user!'].include?(status)
      color = 'red'
      font_weight = 'bold'
    elsif status == 'Paid'
      color = 'green'
    end

    content_tag(:span, status, style: "color: #{color};font-weight: #{font_weight}")
  end

  def user_icon_png(html_class: '')
    user_icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAMAAADXqc3KAAAAllBMVEUAAAAiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTEiJTF/Cx8WAAAAMXRSTlMAAgMEBQYHCAkKFhcwMTIzODo8b3B0d3h5fJSXoKKjpqqtubzDz9HT2t7g6Onz9ff9NenHaAAAAKJJREFUGBllwYkWQkAABdBHi1SiRSvRSii9//+5zkzOnBlzL5Qgqetkjj43p5Q5MOXsZDAsqMyhS6kk0DVUaugaKjV0ZyoJdCGVAIYLOzlM7oVS7kIz3JSxE56bJl04cbkeoDOuSBaRB3hRQfI1wt+JPUdIPi0+hBUtSwgHWnYQ7rTcIFS0lBA+tLwhPGl5QNjTsoUwadnTepBm1y813+sUwA9NtT5hdtOe/QAAAABJRU5ErkJggg==' # rubocop:disable Metrics/LineLength

    image_tag(user_icon, class: html_class)
  end

  def envelope_icon_png(html_class: '')
    envelope_icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAXVBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9RKvvlAAAAHnRSTlMAAQMIDxASEx4hJjc4XWFoa210mJutsMXHzs/V3P3SjJ/LAAAAWUlEQVQIHQXBCULCQAAAsZRLLKdFBYWd/z+TBADgOqqqalyMCQBDewA+0/MDYPdKm78jcPjfJqvbMjEt3ysJp5/1+veMBPP9MUMCgAwAGL5GVVWNKwAAAPAG8x4GrqYZWpwAAAAASUVORK5CYII=' # rubocop:disable Metrics/LineLength
    style = 'max-width: 12px;vertical-align: middle; margin-right: 5px;'
    image_tag(envelope_icon, class: html_class, style: style)
  end

  def datetime_ago_in_words(datetime)
    created_at = datetime.strftime('%A at %H:%M, %B %d, %Y')
    time_ago_in_words = distance_of_time_in_words(Time.zone.now, datetime)
    "#{time_ago_in_words} ago on #{created_at}"
  end

  def download_link_to(url:, file_name:, title: I18n.t('admin.download'))
    link_to(title, url, download: file_name)
  end

  def job_user_translations_path(job_user)
    admin_job_user_translations_path + AdminHelpers::Link.query(:job_user_id, job_user.id)
  end

  def european_date(datetime)
    datetime&.strftime('%Y-%m-%d')
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

  def job_languages_badges(job_languages:)
    links = job_languages.map do |job_language|
      job_language_badge(language: job_language.language, job_language: job_language)
    end

    safe_join(links, ' ')
  end

  def job_language_badge(language:, job_language: nil)
    path = AdminHelpers::Link.query(:job_languages_language_id, language.id)
    simple_link_badge_tag(
      language.name,
      admin_users_path + path,
      value: job_language&.proficiency,
      value_by_admin: job_language&.proficiency_by_admin
    )
  end

  def job_skills_badges(job_skills:, join_with: ' ')
    links = job_skills.map do |job_skill|
      job_skill_badge(skill: job_skill.skill, job_skill: job_skill)
    end

    safe_join(links, join_with)
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
