# frozen_string_literal: true
ActiveAdmin.register Job do
  permit_params do
    extras = [:cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id]
    JobPolicy::FULL_ATTRIBUTES + extras
  end
end
