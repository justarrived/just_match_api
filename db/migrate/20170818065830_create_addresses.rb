# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :municipality
      t.string :country_code

      t.string :uuid, limit: 36, index: true # Max UUID length is 36, see https://tools.ietf.org/html/rfc4122#section-3

      t.with_options precision: 15, scale: 10 do |c|
        c.decimal :latitude
        c.decimal :longitude
      end

      t.timestamps
    end
  end
end
