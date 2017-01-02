# frozen_string_literal: true
ActiveAdmin.register UserTag do
  menu parent: 'Users'

  index do
    selectable_column

    column :id
    column :name do |user_tag|
      url = admin_users_path + AdminHelpers::Link.query(:user_tags_tag_id, user_tag.tag.id) # rubocop:disable Metrics/LineLength
      link_to(user_tag.tag.display_name, url)
    end
    column :created_at

    actions
  end

  permit_params do
    [:user_id, :tag_id]
  end

  controller do
    def scoped_collection
      super.includes(:tag)
    end
  end
end
