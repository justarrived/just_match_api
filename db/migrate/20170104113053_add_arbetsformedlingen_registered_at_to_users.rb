# frozen_string_literal: true
class AddArbetsformedlingenRegisteredAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :arbetsformedlingen_registered_at, :date
  end
end
