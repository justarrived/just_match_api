# frozen_string_literal: true
class AddHourlyPayReferenceToJobs < ActiveRecord::Migration
  def change
    add_reference :jobs, :hourly_pay, index: true, foreign_key: true
  end
end
