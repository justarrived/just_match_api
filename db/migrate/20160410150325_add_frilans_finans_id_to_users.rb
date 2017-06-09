# frozen_string_literal: true

class AddFrilansFinansIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :frilans_finans_id, :integer
    add_index :users, :frilans_finans_id, unique: true
  end
end
