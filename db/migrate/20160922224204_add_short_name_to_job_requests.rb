# frozen_string_literal: true

class AddShortNameToJobRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :job_requests, :short_name, :string
  end
end
