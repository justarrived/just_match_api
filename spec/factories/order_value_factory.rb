# frozen_string_literal: true

FactoryGirl.define do
  factory :order_value do
    association :order
    previous_order_value nil
    change_comment 'MyText'
    change_reason_category 1
    total_sold '9.99'
  end
end

# == Schema Information
#
# Table name: order_values
#
#  id                      :integer          not null, primary key
#  order_id                :integer
#  previous_order_value_id :integer
#  change_comment          :text
#  change_reason_category  :integer
#  total_sold              :decimal(, )
#  sold_hourly_salary      :decimal(, )
#  sold_hourly_price       :decimal(, )
#  sold_hours_per_month    :decimal(, )
#  sold_number_of_months   :decimal(, )
#  total_filled            :decimal(, )
#  filled_hourly_salary    :decimal(, )
#  filled_hourly_price     :decimal(, )
#  filled_hours_per_month  :decimal(, )
#  filled_number_of_months :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_order_values_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...                (order_id => orders.id)
#  previous_order_value_id_fk  (previous_order_value_id => order_values.id)
#
