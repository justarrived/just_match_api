# frozen_string_literal: true
ActiveAdmin.register Tag do
  menu parent: 'Settings'

  permit_params do
    [:name, :color]
  end
end
