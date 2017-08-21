# frozen_string_literal: true

class CreateJobDigests < ActiveRecord::Migration[5.1]
  def change
    create_table :job_digests do |t|
      t.string :city
      t.integer :notification_frequency

      t.belongs_to :job_digest_subscriber, foreign_key: true

      t.timestamps
    end
  end
end
