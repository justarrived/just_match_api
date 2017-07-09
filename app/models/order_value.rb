# frozen_string_literal: true

class OrderValue < ApplicationRecord
  belongs_to :order
  belongs_to :previous_order_value, class_name: 'OrderValue', foreign_key: 'previous_order_value_id' # rubocop:disable Metrics/LineLength

  validates :order, presence: true
  validates :previous_order_value, uniqueness: true, allow_nil: true

  validate :validate_order_sold_total_possible_to_calculate
  validate :validate_order_filled_total_possible_to_calculate

  def filled_percentage(round: nil)
    percentage = (filled_total_value / sold_total_value) * 100

    percentage.round(round) if round
    percentage
  end

  def total_sold_value_change
    return 0.0 if previous_order_value.nil?

    sold_total_value - previous_order_value.sold_total_value
  end

  def total_filled_value_change
    return 0.0 if previous_order_value.nil?

    filled_total_value - previous_order_value.filled_total_value
  end

  def validate_order_sold_total_possible_to_calculate
    return if total_sold
    return if sold_hourly_price && sold_hours_per_month && sold_number_of_months

    error_message = I18n.t('errors.order_value.must_be_able_to_calulate_total')
    errors.add(:total_sold, error_message) if total_sold.nil?

    if sold_hourly_price.nil?
      errors.add(:sold_hourly_price, I18n.t('errors.order_value.hourly_price_presence'))
    end

    if sold_hours_per_month.nil?
      error_message = I18n.t('errors.order_value.hours_per_month_presence')
      errors.add(:sold_hours_per_month, error_message)
    end

    if sold_number_of_months.nil?
      month_errors = I18n.t('errors.order_value.number_of_months_presence')
      errors.add(:sold_number_of_months, month_errors)
    end
  end

  def validate_order_filled_total_possible_to_calculate
    return if total_filled
    return if filled_hourly_price && filled_hours_per_month && filled_number_of_months

    error_message = I18n.t('errors.order_value.must_be_able_to_calulate_total')
    errors.add(:total_filled, error_message) if total_filled.nil?

    if filled_hourly_price.nil?
      errors.add(:filled_hourly_price, I18n.t('errors.order_value.hourly_price_presence'))
    end

    if filled_hours_per_month.nil?
      error_message = I18n.t('errors.order_value.hours_per_month_presence')
      errors.add(:filled_hours_per_month, error_message)
    end

    if filled_number_of_months.nil?
      month_errors = I18n.t('errors.order_value.number_of_months_presence')
      errors.add(:filled_number_of_months, month_errors)
    end
  end

  def sold_total_value
    total_sold || calculate_total_sold_value
  end

  def filled_total_value
    return total_filled || 0.0 if total_sold

    calculate_total_filled_value
  end

  def calculate_total_sold_value
    sold_hourly_price * sold_hours_per_month * sold_number_of_months
  end

  def calculate_total_filled_value
    filled_hourly_price * filled_hours_per_month * filled_number_of_months
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
