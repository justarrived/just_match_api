# frozen_string_literal: true
ActiveAdmin.register Chat do
  menu parent: 'Misc'

  batch_action :destroy, false
end
