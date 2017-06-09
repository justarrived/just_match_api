# frozen_string_literal: true

class AddSsnToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ssn, :string
  end
end
