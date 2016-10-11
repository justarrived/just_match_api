ActiveAdmin.register HourlyPay do
  permit_params do
    [:gross_salary, :active]
  end
end
