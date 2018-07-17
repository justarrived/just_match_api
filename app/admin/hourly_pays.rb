# frozen_string_literal: true

ActiveAdmin.register HourlyPay do
  menu parent: 'Settings'

  batch_action :destroy, false

  permit_params do
    %i(gross_salary active)
  end
end
