# frozen_string_literal: true

class AddAcceptedAtDateToJobUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :job_users, :accepted_at, :datetime
  end
end
