# frozen_string_literal: true
ActiveAdmin.register Job do
  permit_params do
    relations = [:language_id, :hourly_pay_id, :category_id, :owner_user_id]
    JobPolicy::FULL_ATTRIBUTES + relations
  end
end
