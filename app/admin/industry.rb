# frozen_string_literal: true

ActiveAdmin.register Industry do
  menu parent: 'Settings'

  permit_params do
    %i(name parent_id)
  end
end
