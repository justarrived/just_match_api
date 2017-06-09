# frozen_string_literal: true

class RemovePerformedAndPerformedAcceptedFronJobs < ActiveRecord::Migration[4.2]
  def change
    remove_column :jobs, :performed, :boolean
    remove_column :jobs, :performed_accept, :boolean
  end
end
