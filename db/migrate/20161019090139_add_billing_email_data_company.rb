# frozen_string_literal: true
class AddBillingEmailDataCompany < ActiveRecord::Migration[5.0]
  def up
    Company.all.map do |company|
      email = company.email
      company.billing_email = email
      company.save!
    end
  end

  def down
    Company.update_all(billing_email: nil)
  end
end
