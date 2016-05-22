# frozen_string_literal: true
class CreateFrilansFinansInvoices < ActiveRecord::Migration
  def change
    create_table :frilans_finans_invoices do |t|
      t.integer :frilans_finans_id, unique: true
      t.belongs_to :job_user, index: true, foreign_key: true, unique: true

      t.timestamps null: false
    end
  end
end
