# frozen_string_literal: true

class CreateRecruiterActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :recruiter_activities do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :activity, foreign_key: true
      t.text :body
      t.belongs_to :document, foreign_key: true

      t.timestamps
    end
  end
end
