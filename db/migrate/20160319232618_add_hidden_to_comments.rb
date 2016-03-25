# frozen_string_literal: true
class AddHiddenToComments < ActiveRecord::Migration
  def change
    add_column :comments, :hidden, :boolean, default: false
  end
end
