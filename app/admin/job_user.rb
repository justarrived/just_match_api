# frozen_string_literal: true
ActiveAdmin.register JobUser do
  permit_params do
    [:accepted, :will_perform, :performed, :apply_message]
  end
end
