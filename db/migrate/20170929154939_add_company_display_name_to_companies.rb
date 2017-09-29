# frozen_string_literal: true

class AddCompanyDisplayNameToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :display_name, :string
  end
end
