# frozen_string_literal: true

class AddCompanyRelationToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :company, index: true, foreign_key: true
  end
end
