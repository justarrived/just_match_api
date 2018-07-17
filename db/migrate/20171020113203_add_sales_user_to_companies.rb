# frozen_string_literal: true

class AddSalesUserToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :sales_user_id, :integer
    add_foreign_key 'companies', 'users', column: 'sales_user_id', name: 'companies_sales_user_id_fk' # rubocop:disable Metrics/LineLength
  end
end
