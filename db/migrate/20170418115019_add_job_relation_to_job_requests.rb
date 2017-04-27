# frozen_string_literal: true

class AddJobRelationToJobRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :job_requests, :job, foreign_key: true
  end
end
