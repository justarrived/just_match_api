# frozen_string_literal: true
ActiveAdmin.register Tag do
  menu parent: 'Settings'

  index do
    selectable_column

    column :id
    column :name do |tag|
      user_tag_badge(tag: tag)
    end
    column :updated_at

    actions
  end

  permit_params do
    [:name, :color]
  end
end
