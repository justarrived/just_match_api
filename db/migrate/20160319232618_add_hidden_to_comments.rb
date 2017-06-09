# frozen_string_literal: true

class AddHiddenToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :hidden, :boolean, default: false
  end
end
