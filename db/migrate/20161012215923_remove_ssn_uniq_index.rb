# frozen_string_literal: true

class RemoveSsnUniqIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :users, :ssn
  end
end
