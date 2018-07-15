# frozen_string_literal: true

class RemoveAnonymizedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :anonymized, :boolean
  end
end
