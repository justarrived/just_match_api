# frozen_string_literal: true

ActiveAdmin.register Category do
  menu parent: 'Settings'

  actions :index, :show

  batch_action :destroy, false
end
