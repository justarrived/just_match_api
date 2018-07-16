# frozen_string_literal: true

class AddAnonymizationRequestedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :anonymization_requested_at, :datetime
  end
end
