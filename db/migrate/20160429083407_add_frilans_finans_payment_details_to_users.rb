# frozen_string_literal: true

class AddFrilansFinansPaymentDetailsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :frilans_finans_payment_details, :boolean, default: false
  end
end
