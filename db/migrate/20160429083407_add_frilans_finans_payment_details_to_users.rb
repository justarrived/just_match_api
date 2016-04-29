# frozen_string_literal: true
class AddFrilansFinansPaymentDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :frilans_finans_payment_details, :boolean, default: false
  end
end
