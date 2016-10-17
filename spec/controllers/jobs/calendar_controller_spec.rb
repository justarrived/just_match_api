# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::CalendarController, type: :controller do
  context '#google' do
    let(:job) { FactoryGirl.create(:job) }

    it 'returns google calendar link' do
      get :google, params: { job_id: job.id }

      json = JSON.parse(response.body)

      url_part = 'https://www.google.com/calendar/render?action=TEMPLATE'
      expect(json.dig('data', 'attributes', 'template-url')).to include(url_part)
    end
  end
end
