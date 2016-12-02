# frozen_string_literal: true
ActiveAdmin.register HourlyPay do
  menu parent: 'Misc'

  batch_action :destroy, false

  permit_params do
    [:gross_salary, :active]
  end
end
