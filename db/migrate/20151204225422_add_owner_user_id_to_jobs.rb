# frozen_string_literal: true

class AddOwnerUserIdToJobs < ActiveRecord::Migration[4.2]
  def change
    add_column :jobs, :owner_user_id, :integer
  end
end
