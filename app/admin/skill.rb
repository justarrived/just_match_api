# frozen_string_literal: true
ActiveAdmin.register Skill do
  menu parent: 'Settings'

  permit_params do
    [:name, :color, :internal, :language_id]
  end
end
