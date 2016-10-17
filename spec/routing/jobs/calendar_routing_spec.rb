# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::CalendarController, type: :routing do
  describe 'routing' do
    it 'routes to #google' do
      path = '/api/v1/jobs/1/calendar/google'
      route_path = 'api/v1/jobs/calendar#google'
      expect(get: path).to route_to(route_path, job_id: '1')
    end
  end
end
