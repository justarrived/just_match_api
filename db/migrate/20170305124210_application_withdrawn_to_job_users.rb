# frozen_string_literal: true

class ApplicationWithdrawnToJobUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_users, :application_withdrawn, :boolean, default: false
  end
end
