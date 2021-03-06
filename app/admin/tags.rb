# frozen_string_literal: true

ActiveAdmin.register Tag do
  menu parent: 'Settings'

  filter :name
  filter :created_at
  filter :updated_at

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
    %i(name color)
  end
end
