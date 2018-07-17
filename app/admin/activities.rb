# frozen_string_literal: true

ActiveAdmin.register Activity do
  menu parent: 'Settings'

  actions :index, :show, :new, :create, :edit, :update

  permit_params do
    %i[name]
  end
end
