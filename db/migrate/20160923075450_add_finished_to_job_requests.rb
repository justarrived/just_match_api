# frozen_string_literal: true

class AddFinishedToJobRequests < ActiveRecord::Migration
  def change
    add_column :job_requests, :finished, :boolean, default: false
  end
end
