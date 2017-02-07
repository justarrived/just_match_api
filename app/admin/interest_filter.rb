# frozen_string_literal: true
ActiveAdmin.register InterestFilter do
  menu parent: 'Filters'

  permit_params do
    [:interest_id, :filter_id, :level, :level_by_admin]
  end
end
