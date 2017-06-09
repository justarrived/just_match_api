# frozen_string_literal: true

class AddWebsiteToCompanies < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :website, :string
  end
end
