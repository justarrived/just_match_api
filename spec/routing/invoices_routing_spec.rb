# frozen_string_literal: true
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

require 'rails_helper'

RSpec.describe Api::V1::Jobs::InvoicesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/jobs/1/users/1/invoices'
      route_path = 'api/v1/jobs/invoices#create'
      expect(post: path).to route_to(route_path, job_id: '1', job_user_id: '1')
    end
  end
end
