# frozen_string_literal: true
class AddUniqIndexForUsersAndCompaniesForIdentifiers < ActiveRecord::Migration
  def change
    add_index :users, :ssn, unique: true
    add_index :companies, :cin, unique: true
  end
end
