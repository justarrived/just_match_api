# frozen_string_literal: true

class AddMunicipalityToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :municipality, :string
  end
end
