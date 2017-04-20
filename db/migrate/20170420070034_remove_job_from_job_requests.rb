# frozen_string_literal: true

class RemoveJobFromJobRequests < ActiveRecord::Migration[5.0]
  def change
    remove_reference :job_requests, :job, foreign_key: true
  end
end
