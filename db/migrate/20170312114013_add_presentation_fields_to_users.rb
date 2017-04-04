# frozen_string_literal: true
class AddPresentationFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :presentation_profile, :text
    add_column :users, :presentation_personality, :text
    add_column :users, :presentation_availability, :text
  end
end
