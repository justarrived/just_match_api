# frozen_string_literal: true

ActiveAdmin.register OrderValue do
  menu parent: 'Sales'

  index do
    selectable_column

    column :order
    column :change_reason_category
    column :total_sold_value_change

    column :total_filled_over_sold_order_value do |order_value|
      total_filled_over_sold_order_value(order_value)
    end

    actions
  end

  show do
    attributes_table do
      row :order
      row :previous_order_value

      row :total_filled_over_sold_order_value do |order_value|
        total_filled_over_sold_order_value(order_value)
      end

      row :change_comment
      row :change_reason_category

      row :total_sold_value_change
      row :sold_total_value
      row :total_sold
      row :total_filled

      row :sold_hourly_salary
      row :sold_hourly_price
      row :sold_hours_per_month
      row :sold_number_of_months

      row :filled_total_value
    end

    active_admin_comments
  end

  permit_params do
    %i(
      order_id
      previous_order_value_id
      change_comment
      change_reason_category
      total_sold
      total_filled
      sold_hourly_salary
      sold_hourly_price
      sold_hours_per_month
      sold_number_of_months
      filled_hourly_salary
      filled_hourly_price
      filled_hours_per_month
      filled_number_of_months
    )
  end
end
