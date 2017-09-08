# frozen_string_literal: true

class AddJobInvoiceCommentToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :invoice_comment, :text
  end
end
