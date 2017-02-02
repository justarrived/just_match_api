# frozen_string_literal: true
ActiveAdmin.register Filter do
  permit_params do
    [:name]
  end
end
