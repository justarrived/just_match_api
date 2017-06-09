# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[4.2]
  def change
    create_table :ratings do |t|
      t.references :from_user, references: :users
      t.references :to_user, references: :users

      t.belongs_to :job

      t.integer :score, null: false

      t.timestamps null: false
    end

    # rubocop:disable Metrics/LineLength
    add_foreign_key :ratings, :users, column: 'from_user_id', name: 'ratings_from_user_id_fk'
    # rubocop:enable Metrics/LineLength
    add_foreign_key :ratings, :jobs, name: 'ratings_job_id_fk'
    add_foreign_key :ratings, :users, column: 'to_user_id', name: 'ratings_to_user_id_fk'

    add_index :ratings, %i(job_id from_user_id), unique: true
    add_index :ratings, %i(job_id to_user_id), unique: true
  end
end
