class CreateJobSkills < ActiveRecord::Migration
  def change
    create_table :job_skills do |t|
      t.belongs_to :job, index: true, foreign_key: true
      t.belongs_to :skill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
