# frozen_string_literal: true
class AddBillingEmailToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :billing_email, :string
  end
end
