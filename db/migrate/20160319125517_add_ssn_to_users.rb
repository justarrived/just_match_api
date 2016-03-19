# frozen_string_literal: true
class AddSsnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ssn, :string
  end
end
