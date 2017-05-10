# frozen_string_literal: true

class AddLastApplicationAtToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :last_application_at, :datetime
  end
end
