# frozen_string_literal: true
class AddFrilansFinansIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :frilans_finans_id, :integer
    add_index :users, :frilans_finans_id, unique: true
  end
end
