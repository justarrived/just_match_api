# frozen_string_literal: true
ActiveAdmin.register Tag do
  permit_params do
    [:name, :color]
  end
end
