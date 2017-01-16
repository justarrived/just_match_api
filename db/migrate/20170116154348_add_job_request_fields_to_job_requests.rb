# frozen_string_literal: true
class AddJobRequestFieldsToJobRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :job_requests, :cancelled, :boolean, default: false
    add_column :job_requests, :draft_sent, :boolean, default: false
    add_column :job_requests, :signed_by_customer, :boolean, default: false
    add_column :job_requests, :requirements, :string
    add_column :job_requests, :hourly_pay, :string
    add_column :job_requests, :company_org_no, :string
    add_column :job_requests, :company_email, :string
    add_column :job_requests, :company_phone, :string
  end
end
