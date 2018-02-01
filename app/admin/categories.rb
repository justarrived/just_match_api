# frozen_string_literal: true

ActiveAdmin.register Category do
  menu parent: 'Settings'

  batch_action :destroy, false
end
