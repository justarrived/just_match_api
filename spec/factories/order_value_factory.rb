# frozen_string_literal: true

FactoryBot.define do
  factory :order_value do
    association :order
    association :changed_by_user, factory: :user

    change_comment 'MyText'
    change_reason_category 1
    total_sold nil
    total_filled '4000'
    sold_hourly_salary 200
    sold_hourly_price 400
    sold_hours_per_month 160
    sold_number_of_months 1
  end
end

# == Schema Information
#
# Table name: order_values
#
#  id                      :bigint(8)        not null, primary key
#  order_id                :bigint(8)
#  previous_order_value_id :integer
#  change_comment          :text
#  change_reason_category  :integer
#  sold_hourly_salary      :decimal(, )
#  sold_hourly_price       :decimal(, )
#  sold_hours_per_month    :decimal(, )
#  sold_number_of_months   :decimal(, )
#  total_sold              :decimal(, )
#  total_filled            :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  changed_by_user_id      :integer
#
# Indexes
#
#  index_order_values_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...                        (order_id => orders.id)
#  order_values_changed_by_user_id_fk  (changed_by_user_id => users.id)
#  previous_order_value_id_fk          (previous_order_value_id => order_values.id)
#
