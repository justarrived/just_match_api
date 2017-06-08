# frozen_string_literal: true

class InvoiceSerializer < ApplicationSerializer
  belongs_to :job_user
end

# == Schema Information
#
# Table name: invoices
#
#  id                        :integer          not null, primary key
#  job_user_id               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  frilans_finans_invoice_id :integer
#
# Indexes
#
#  index_invoices_on_frilans_finans_invoice_id  (frilans_finans_invoice_id)
#  index_invoices_on_job_user_id                (job_user_id)
#  index_invoices_on_job_user_id_uniq           (job_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (frilans_finans_invoice_id => frilans_finans_invoices.id)
#  fk_rails_...  (job_user_id => job_users.id)
#
