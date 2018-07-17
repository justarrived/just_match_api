# frozen_string_literal: true

ActiveAdmin.register UserTag do
  menu parent: 'Users'

  filter :tag
  filter :created_at

  index do
    selectable_column

    column :id
    column :name do |user_tag|
      tag = user_tag.tag

      link_to(
        tag.name,
        admin_users_path + AdminHelpers::Link.query(:user_tags_tag_id, tag.id),
        class: 'user-badge-tag-link',
        style: "background-color: #{tag.color}"
      )
    end
    column :user
    column :created_at

    actions
  end

  permit_params do
    %i(user_id tag_id)
  end

  controller do
    def scoped_collection
      super.includes(:user, :tag)
    end
  end
end
