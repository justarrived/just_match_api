# frozen_string_literal: true

class AddTrackingFieldsToJobUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :job_users, :http_referrer, :string, limit: 2083 # Max URL length is 2083
    add_column :job_users, :utm_source, :string
    add_column :job_users, :utm_medium, :string
    add_column :job_users, :utm_campaign, :string
    add_column :job_users, :utm_term, :string
    add_column :job_users, :utm_content, :string
  end
end
