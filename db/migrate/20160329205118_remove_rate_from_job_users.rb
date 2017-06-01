# frozen_string_literal: true

class RemoveRateFromJobUsers < ActiveRecord::Migration
  def change
    remove_column :job_users, :rate, :integer
  end
end
