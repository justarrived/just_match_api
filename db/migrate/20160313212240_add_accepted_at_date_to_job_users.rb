# frozen_string_literal: true

class AddAcceptedAtDateToJobUsers < ActiveRecord::Migration
  def change
    add_column :job_users, :accepted_at, :datetime
  end
end
