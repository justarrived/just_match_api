# frozen_string_literal: true

class AddFrilansFinansIdToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :frilans_finans_id, :integer
    add_index :categories, :frilans_finans_id, unique: true
  end
end
