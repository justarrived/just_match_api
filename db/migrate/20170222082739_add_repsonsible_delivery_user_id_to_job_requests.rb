# frozen_string_literal: true

class AddRepsonsibleDeliveryUserIdToJobRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :job_requests, :delivery_user_id, :integer
    add_column :job_requests, :sales_user_id, :integer
  end
end
