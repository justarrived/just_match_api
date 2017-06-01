# frozen_string_literal: true

class RemovePerformedAcceptedFromJobUsers < ActiveRecord::Migration
  def change
    remove_column :job_users, :performed_accepted, :boolean
  end
end
