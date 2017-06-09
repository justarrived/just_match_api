# frozen_string_literal: true

class AddInsuranceStatusToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :insurance_status, :integer
  end
end
