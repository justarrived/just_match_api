# frozen_string_literal: true
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
