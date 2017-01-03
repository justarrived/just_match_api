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

  def colored_badge_tag(name, color)
    content_tag(
      :span,
      name,
      class: 'user-badge-tag-link',
      style: "background-color: #{color}"
    )
  end
end
