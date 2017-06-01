# frozen_string_literal: true

class AddVerifiedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :verified, :boolean, default: false
  end
end
