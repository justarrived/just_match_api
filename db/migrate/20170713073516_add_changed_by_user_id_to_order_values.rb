# frozen_string_literal: true

class AddChangedByUserIdToOrderValues < ActiveRecord::Migration[5.1]
  def change
    add_column :order_values, :changed_by_user_id, :integer
  end
end
