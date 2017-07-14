# frozen_string_literal: true

class AddCustomerHourlyPriceToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :customer_hourly_price, :decimal
  end
end
