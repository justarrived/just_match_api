# frozen_string_literal: true
class AddJustArrivedContactUserToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :just_arrived_contact_user_id, :integer
    add_foreign_key 'jobs', 'users', column: 'just_arrived_contact_user_id', name: 'jobs_just_arrived_contact_user_id_fk' # rubocop:disable Metrics/LineLength
  end
end
