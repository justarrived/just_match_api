# frozen_string_literal: true
class AddClosestRelationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :next_of_kin_name, :string
    add_column :users, :next_of_kin_phone, :string
  end
end
