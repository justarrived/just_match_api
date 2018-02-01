# frozen_string_literal: true

class CreateEmploymentPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :employment_periods do |t|
      t.belongs_to :job_user, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :employer_signed_at
      t.datetime :employee_signed_at
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
