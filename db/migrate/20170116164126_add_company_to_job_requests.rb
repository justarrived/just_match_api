class AddCompanyToJobRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :job_requests, :company, foreign_key: true
  end
end
