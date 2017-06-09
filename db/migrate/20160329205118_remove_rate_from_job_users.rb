# frozen_string_literal: true

class RemoveRateFromJobUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :job_users, :rate, :integer
  end
end
