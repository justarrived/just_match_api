# frozen_string_literal: true

class CreateJobLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :job_languages do |t|
      t.belongs_to :job, foreign_key: true
      t.belongs_to :language, foreign_key: true
      t.integer :proficiency
      t.integer :proficiency_by_admin

      t.timestamps
    end
  end
end
