# frozen_string_literal: true
ActiveAdmin.register Tag do
  menu parent: 'Settings'

  index do
    column :name
    column :color do |tag|
      colored_badge_tag(tag.color, tag.color)
    end

    actions
  end

  permit_params do
    [:name, :color]
  end
end
