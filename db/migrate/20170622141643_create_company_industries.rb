# frozen_string_literal: true

class CreateCompanyIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :company_industries do |t|
      t.belongs_to :company, foreign_key: true
      t.belongs_to :industry, foreign_key: true

      t.timestamps
    end
  end
end
