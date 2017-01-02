# frozen_string_literal: true
module AdminHelper
  def user_tag_badges(user:)
    tag_links = user.tags.map { |tag| user_tag_badge(user: user, tag: tag) }
    safe_join(tag_links, ', ')
  end

  def user_tag_badge(user:, tag:)
    link_to(
      tag.name,
      admin_tag_path(tag),
      class: 'user-badge-tag-link',
      style: "background-color: #{tag.color}"
    )
  end
end
