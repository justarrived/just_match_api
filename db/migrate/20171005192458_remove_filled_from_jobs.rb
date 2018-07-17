# frozen_string_literal: true

class RemoveFilledFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :filled, :boolean
  end
end
