# frozen_string_literal: true
class AddMissingAhoyKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key 'ahoy_events', 'users', name: 'ahoy_events_user_id_fk'
    add_foreign_key 'ahoy_events', 'visits', name: 'ahoy_events_visit_id_fk'
    add_foreign_key 'visits', 'users', name: 'visits_user_id_fk'
  end
end
