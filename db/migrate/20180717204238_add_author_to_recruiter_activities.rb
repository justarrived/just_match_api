# frozen_string_literal: true

class AddAuthorToRecruiterActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :recruiter_activities, :author_id, :integer
    add_index :recruiter_activities, :author_id
  end
end
