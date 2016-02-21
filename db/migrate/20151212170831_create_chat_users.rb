# frozen_string_literal: true
class CreateChatUsers < ActiveRecord::Migration
  def change
    create_table :chat_users do |t|
      t.belongs_to :chat, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
