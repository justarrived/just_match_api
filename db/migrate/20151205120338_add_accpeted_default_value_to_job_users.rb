# frozen_string_literal: true

class AddAccpetedDefaultValueToJobUsers < ActiveRecord::Migration[4.2]
  def change
    # rubocop:disable Rails/ReversibleMigration
    change_column_default :job_users, :accepted, false
    # rubocop:enable Rails/ReversibleMigration
  end
end
