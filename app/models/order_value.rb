# frozen_string_literal: true

class OrderValue < ApplicationRecord
  belongs_to :order
  belongs_to :previous_order_value, class_name: 'OrderValue', foreign_key: 'previous_order_value_id', optional: true # rubocop:disable Metrics/LineLength
  belongs_to :changed_by_user, class_name: 'User', foreign_key: 'changed_by_user_id'

  validates :order, presence: true
  validates :previous_order_value, uniqueness: true, allow_nil: true
  validates :change_comment, presence: true, unless: :first_order_value?
  validates :change_reason_category, presence: true, unless: :first_order_value?

  validates :sold_hours_per_month, numericality: { greater_than_or_equal_to: 0.1 }, allow_blank: true # rubocop:disable Metrics/LineLength
  validates :sold_number_of_months, numericality: { greater_than_or_equal_to: 1.0, less_than_or_equal_to: 6.0 }, allow_blank: true # rubocop:disable Metrics/LineLength

  validate :validate_order_sold_total_possible_to_calculate

  CHANGE_CATEGORIES = {
    competition: 1,
    no_suitable_candidate: 2,
    changes_in_the_customer_demand: 3,
    not_a_well_established_order: 4,
    other: 5,
    extension: 6
  }.freeze

  enum change_reason_category: CHANGE_CATEGORIES

  def first_order_value?
    return true if order.nil?
    return true if order.new_record?
    return true if (order.order_values - [self]).empty?

    false
  end

  def filled_percentage(round: nil)
    percentage = (filled_total_value / sold_total_value) * 100

    return percentage.round(round) if round
    percentage
  end

  def filled_total_value
    return total_filled if total_sold

    calculate_total_filled_value
  end

  def calculate_total_filled_value
    order.filled_jobs.inject(0) do |sum, job|
      sum + job.customer_invoice_amount * job.number_to_fill
    end
  end

  def total_sold_value_change
    return 0.0 unless previous_order_value

    sold_total_value - previous_order_value.sold_total_value
  end

  def validate_order_sold_total_possible_to_calculate
    return if total_sold
    return if sold_hourly_price && sold_hours_per_month && sold_number_of_months

    error_message = I18n.t('errors.order_value.must_be_able_to_calulate_total')
    errors.add(:total_sold, error_message) unless total_sold

    unless sold_hourly_price
      errors.add(:sold_hourly_price, I18n.t('errors.order_value.hourly_price_presence'))
    end

    unless sold_hours_per_month
      error_message = I18n.t('errors.order_value.hours_per_month_presence')
      errors.add(:sold_hours_per_month, error_message)
    end

    unless sold_number_of_months
      month_errors = I18n.t('errors.order_value.number_of_months_presence')
      errors.add(:sold_number_of_months, month_errors)
    end
  end

  def sold_total_value
    total_sold || calculate_total_sold_value
  end

  def calculate_total_sold_value
    sold_hourly_price * sold_hours_per_month * sold_number_of_months
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
