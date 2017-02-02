# frozen_string_literal: true
ActiveAdmin.register InterestFilter do
  permit_params do
    [:interest_id, :filter_id, :level, :level_by_admin]
  end
end
