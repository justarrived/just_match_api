# frozen_string_literal: true
# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_invoices_on_job_user_id        (job_user_id)
#
# Foreign Keys
#
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
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
