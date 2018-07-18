# frozen_string_literal: true

class RemoveVerifiedFromJobsAndUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :verified, :boolean
    remove_column :users, :verified, :boolean
  end
end
