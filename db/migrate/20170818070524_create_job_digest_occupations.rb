# frozen_string_literal: true

class CreateJobDigestOccupations < ActiveRecord::Migration[5.1]
  def change
    create_table :job_digest_occupations do |t|
      t.belongs_to :job_digest, foreign_key: true
      t.belongs_to :occupation, foreign_key: true

      t.timestamps
    end
  end
end
