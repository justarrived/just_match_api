# frozen_string_literal: true
class AddCompanyRelationToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :company, index: true, foreign_key: true
  end
end
