# frozen_string_literal: true

class RemoveInterviewedByUserIdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :interviewed_by_user_id, :integer
  end
end
