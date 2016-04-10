# frozen_string_literal: true
class AddFrilansFinansIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :frilans_finans_id, :integer
    add_index :companies, :frilans_finans_id, unique: true
  end
end
