# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderValue, type: :model do
  describe '#first_order_value?' do
    it 'returns true for order value with no order' do
      order_value = OrderValue.new(order: Order.new)
      expect(order_value.first_order_value?).to eq(true)
    end

    it 'returns true for order value that belongs to an non-persited order' do
      order_value = OrderValue.new(order: Order.new)
      expect(order_value.first_order_value?).to eq(true)
    end

    it 'returns false for order value that belongs to an order with existing order values' do # rubocop:disable Metrics/LineLength
      order_value = OrderValue.new(order: Order.new)
      expect(order_value.first_order_value?).to eq(true)
    end
  end

  describe '#total_sold_value_change' do
    it 'returns 0 if there is no previous order value' do
      expect(OrderValue.new.total_sold_value_change).to be_zero
    end

    it 'returns total changed value' do
      order_value = OrderValue.new(
        previous_order_value: OrderValue.new(total_sold: 100),
        total_sold: 50
      )
      expect(order_value.total_sold_value_change).to eq(-50.0)
    end
  end

  describe '#validate_order_sold_total_possible_to_calculate' do
    it 'adds no error if total_sold is present' do
      order_value = OrderValue.new(total_sold: 13_000)
      order_value.validate_order_sold_total_possible_to_calculate

      expect(order_value.errors.any?).to eq(false)
    end

    it 'adds no error if hourly_price, hours_per_month, number_of_months are present' do
      order_value = OrderValue.new(
        sold_hourly_price: 300,
        sold_hours_per_month: 100,
        sold_number_of_months: 2
      )
      order_value.validate_order_sold_total_possible_to_calculate

      expect(order_value.errors.any?).to eq(false)
    end

    it 'adds errors if total_sold and other fields are not present' do
      order_value = OrderValue.new
      order_value.validate_order_sold_total_possible_to_calculate

      error_message = I18n.t('errors.order_value.must_be_able_to_calulate_total')
      expect(order_value.errors[:total_sold].first).to eq(error_message)

      error_message = I18n.t('errors.order_value.hourly_price_presence')
      expect(order_value.errors[:sold_hourly_price].first).to eq(error_message)

      error_message = I18n.t('errors.order_value.hours_per_month_presence')
      expect(order_value.errors[:sold_hours_per_month].first).to eq(error_message)

      error_message = I18n.t('errors.order_value.number_of_months_presence')
      expect(order_value.errors[:sold_number_of_months].first).to eq(error_message)
    end
  end

  describe '#sold_total_value' do
    it 'returns total sold value if its present' do
      order_value = OrderValue.new(
        total_sold: 1900,
        sold_hourly_price: 100,
        sold_hours_per_month: 100,
        sold_number_of_months: 1
      )

      expect(order_value.sold_total_value).to eq(1900)
    end

    it 'returns caluclated value tolal sold is blank' do
      order_value = OrderValue.new(
        sold_hourly_price: 100,
        sold_hours_per_month: 100,
        sold_number_of_months: 1
      )

      expect(order_value.sold_total_value).to eq(10_000)
    end
  end

  describe '#filled_total_value' do
    it 'returns total filled value if its present' do
      order_value = OrderValue.new(
        total_sold: 1900,
        total_filled: 1900
      )

      expect(order_value.filled_total_value).to eq(1900)
    end

    it 'returns calculated value tolal filled is blank' do
      order = FactoryGirl.create(:order)
      order_value = FactoryGirl.build(
        :order_value,
        order: order,
        total_sold: 100,
        total_filled: 10_000
      )
      expect(order_value.filled_total_value).to eq(10_000)
    end
  end

  describe '#calculate_total_sold_value' do
    it 'returns total value' do
      order_value = OrderValue.new(
        sold_hourly_price: 100,
        sold_hours_per_month: 100,
        sold_number_of_months: 1
      )

      expect(order_value.calculate_total_sold_value).to eq(10_000)
    end
  end

  describe '#calculate_total_filled_value' do
    it 'returns total value' do
      order = FactoryGirl.create(:order)
      FactoryGirl.create(
        :job,
        filled: true,
        customer_hourly_price: 400.0,
        order: order,
        hours: 40
      )

      order_value = FactoryGirl.build(:order_value, order: order)

      expect(order_value.calculate_total_filled_value).to eq(16_000.0)
    end
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
