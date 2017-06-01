# frozen_string_literal: true

class AddShortNameToJobRequests < ActiveRecord::Migration
  def change
    add_column :job_requests, :short_name, :string
  end
end
