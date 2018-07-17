# frozen_string_literal: true

class RemovePublicProfileFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :public_profile, :boolean
  end
end
