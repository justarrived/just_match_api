# frozen_string_literal: true
class AddAccpetedDefaultValueToJobUsers < ActiveRecord::Migration
  def change
    change_column_default :job_users, :accepted, false
  end
end
