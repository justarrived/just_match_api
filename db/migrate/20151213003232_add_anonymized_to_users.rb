class AddAnonymizedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :anonymized, :boolean, default: false
  end
end
