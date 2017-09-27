# frozen_string_literal: true

class AddStaffingAgencyToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :staffing_agency, :boolean, default: false
  end
end
