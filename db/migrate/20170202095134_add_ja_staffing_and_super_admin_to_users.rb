# frozen_string_literal: true

class AddJaStaffingAndSuperAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :just_arrived_staffing, :boolean, default: false
    add_column :users, :super_admin, :boolean, default: false
  end
end
