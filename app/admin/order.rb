# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params do
    %i(invoice_hourly_pay_rate hours lost job_request_id hourly_pay_id)
  end
end
