# frozen_string_literal: true
class AddMissingUserKeysToJobRequests < ActiveRecord::Migration[5.0]
  def change
    # rubocop:disable Metrics/LineLength
    add_foreign_key 'job_requests', 'users', column: 'delivery_user_id', name: 'job_requests_delivery_user_id_fk'
    add_foreign_key 'job_requests', 'users', column: 'sales_user_id', name: 'job_requests_sales_user_id_fk'
    # rubocop:enable Metrics/LineLength
  end
end
