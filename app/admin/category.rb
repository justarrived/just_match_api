# frozen_string_literal: true
ActiveAdmin.register Category do
  menu parent: 'Misc'

  batch_action :destroy, false
end
