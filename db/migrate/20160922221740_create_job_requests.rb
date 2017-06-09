# frozen_string_literal: true

class CreateJobRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :job_requests do |t|
      t.string :company_name
      t.string :contact_string
      t.string :assignment
      t.string :job_scope
      t.string :job_specification
      t.string :language_requirements
      t.string :job_at_date
      t.string :responsible
      t.string :suitable_candidates
      t.string :comment

      t.timestamps null: false
    end
  end
end
