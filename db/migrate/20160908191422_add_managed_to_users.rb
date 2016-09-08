class AddManagedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :managed, :boolean, default: false
  end
end
