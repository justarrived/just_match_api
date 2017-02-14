# frozen_string_literal: true
ActiveAdmin.register Tag do
  menu parent: 'Settings'

  index do
    column :name
    column :color do |tag|
      simple_badge_tag(tag.color, color: tag.color)
    end

    actions
  end

  permit_params do
    [:name, :color]
  end
end
