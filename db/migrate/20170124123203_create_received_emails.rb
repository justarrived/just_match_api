# frozen_string_literal: true
class CreateReceivedEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :received_emails do |t|
      t.string :from_address
      t.string :to_address
      t.string :subject
      t.text :text_body
      t.text :html_body

      t.timestamps
    end
  end
end
