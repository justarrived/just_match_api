# frozen_string_literal: true

class RemoveInterviewedAtFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :interviewed_at, :datetime
  end
end
