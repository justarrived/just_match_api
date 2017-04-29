# frozen_string_literal: true

class AddFieldsToArbetsformedlingen < ActiveRecord::Migration[5.0]
  def change
	add_column :jobs, :swedish_drivers_license, :string
  end
end
