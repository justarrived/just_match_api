# frozen_string_literal: true

class CreateAhoyEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :ahoy_events do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.integer :visit_id

      # user
      t.integer :user_id
      # add t.string :user_type if polymorphic

      t.string :name
      t.jsonb :properties
      t.timestamp :time
    end

    add_index :ahoy_events, %i(visit_id name)
    add_index :ahoy_events, %i(user_id name)
    add_index :ahoy_events, %i(name time)
  end
end
