class AddIsWorkerAndWorkAreaToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_worker, :boolean, default: false
    add_column :users, :work_area, :decimal, default: 0
  end
end
