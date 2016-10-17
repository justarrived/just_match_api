# frozen_string_literal: true
ActiveAdmin.register HourlyPay do
  permit_params do
    [:gross_salary, :active]
  end
end
