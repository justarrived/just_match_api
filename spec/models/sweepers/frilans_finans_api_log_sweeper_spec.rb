# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::FrilansFinansApiLogSweeper do
  describe '#destroy_old' do
    it 'destorys all old FrilansFinansApiLogs' do
      expect(FrilansFinansApiLog.count).to eq(0)
      log = FactoryGirl.create(:frilans_finans_api_log, created_at: 1.day.ago)
      FactoryGirl.create(:frilans_finans_api_log, created_at: 1.year.ago)

      described_class.destroy_old

      expect(FrilansFinansApiLog.all).to eq([log])
    end
  end
end
