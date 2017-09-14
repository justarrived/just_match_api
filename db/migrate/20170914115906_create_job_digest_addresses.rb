# frozen_string_literal: true

class CreateJobDigestAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :job_digest_addresses do |t|
      t.belongs_to :job_digest, foreign_key: true
      t.belongs_to :address, foreign_key: true

      t.timestamps
    end
  end
end
