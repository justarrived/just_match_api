# frozen_string_literal: true

class AddMissingForeignKeyIndexes < ActiveRecord::Migration
  # rubocop:disable Metrics/LineLength
  def change
    add_foreign_key 'comments', 'users', column: 'owner_user_id', name: 'comments_owner_user_id_fk'
    add_foreign_key 'jobs', 'users', column: 'owner_user_id', name: 'jobs_owner_user_id_fk'
    add_foreign_key 'messages', 'users', column: 'author_id', name: 'messages_author_id_fk'
  end
end
