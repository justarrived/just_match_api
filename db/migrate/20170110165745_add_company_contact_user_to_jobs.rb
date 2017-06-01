# frozen_string_literal: true

class AddCompanyContactUserToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :company_contact_user_id, :integer
    add_foreign_key 'jobs', 'users', column: 'company_contact_user_id', name: 'jobs_company_contact_user_id_fk' # rubocop:disable Metrics/LineLength
  end
end
