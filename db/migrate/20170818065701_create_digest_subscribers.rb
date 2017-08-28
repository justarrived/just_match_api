# frozen_string_literal: true

class CreateDigestSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :digest_subscribers do |t|
      t.string :email
      t.string :uuid, limit: 36 # Max UUID length is 36, see https://tools.ietf.org/html/rfc4122#section-3

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    add_index :digest_subscribers, :uuid, unique: true
  end
end
