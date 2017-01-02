# frozen_string_literal: true
ActiveAdmin.register Tag do
  menu parent: 'Settings'

  index do
    column :name
    column :color do |tag|
      style = "background-color: #{tag.color}"
      span(tag.color, class: 'user-badge-tag-link', style: style)
    end

    actions
  end

  permit_params do
    [:name, :color]
  end
end
