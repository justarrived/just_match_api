# frozen_string_literal: true

class AddInsuranceStatusToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :insurance_status, :integer
  end
end
