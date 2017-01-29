# frozen_string_literal: true
class AddAdditionalInterviewFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :interviewed_by_user_id, :integer
    add_foreign_key 'users', 'users', column: 'interviewed_by_user_id', name: 'users_interviewed_by_user_id_fk' # rubocop:disable Metrics/LineLength
    add_column :users, :interviewed_at, :datetime
  end
end
