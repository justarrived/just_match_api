# frozen_string_literal: true

class AddAnonymizedToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :anonymized, :boolean, default: false
  end
end
