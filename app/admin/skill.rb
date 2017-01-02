# frozen_string_literal: true
ActiveAdmin.register Skill do
  menu parent: 'Settings'

  permit_params do
    [:name, :internal, :language_id]
  end
end
