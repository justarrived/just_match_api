# frozen_string_literal: true

class AddVerifiedToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :verified, :boolean, default: false
  end
end
