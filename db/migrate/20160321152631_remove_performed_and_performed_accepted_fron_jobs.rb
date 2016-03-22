# frozen_string_literal: true
class RemovePerformedAndPerformedAcceptedFronJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :performed, :boolean
    remove_column :jobs, :performed_accept, :boolean
  end
end
