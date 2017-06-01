# frozen_string_literal: true

class RemoveSsnUniqIndex < ActiveRecord::Migration
  def change
    remove_index :users, :ssn
  end
end
