# frozen_string_literal: true
class RemoveNameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name, :string
  end
end
