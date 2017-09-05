# frozen_string_literal: true

class CreateJobDigests < ActiveRecord::Migration[5.1]
  def change
    create_table :job_digests do |t|
      t.belongs_to :address, foreign_key: true
      t.integer :notification_frequency
      t.float :max_distance
      t.string :locale, limit: '10'

      t.datetime :deleted_at

      t.belongs_to :digest_subscriber, foreign_key: true

      t.timestamps
    end
  end
end
