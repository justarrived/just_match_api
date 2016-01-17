class CreateJobUsers < ActiveRecord::Migration
  def change
    create_table :job_users do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :job, index: true, foreign_key: true
      t.boolean :accepted
      t.integer :rate

      t.timestamps null: false
    end
  end
end
