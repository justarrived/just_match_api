class RemoveSsnUniqIndex < ActiveRecord::Migration
  def change
    remove_index :users, :ssn
  end
end
