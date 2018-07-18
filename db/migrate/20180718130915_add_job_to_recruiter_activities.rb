# frozen_string_literal: true

class AddJobToRecruiterActivities < ActiveRecord::Migration[5.2]
  def change
    add_reference :recruiter_activities, :job, foreign_key: true
  end
end
