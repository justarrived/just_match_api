# frozen_string_literal: true

class AddFinishedToJobRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :job_requests, :finished, :boolean, default: false
  end
end
