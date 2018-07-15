# frozen_string_literal: true

class AddUserAnonymizedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :anonymized_at, :datetime
  end
end
